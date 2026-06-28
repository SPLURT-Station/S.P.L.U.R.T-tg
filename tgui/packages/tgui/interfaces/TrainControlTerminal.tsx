import { type ReactNode, useCallback, useEffect, useRef, useState } from 'react';
import {
  Box,
  Button,
  Divider,
  Dropdown,
  Icon,
  Input,
  LabeledList,
  Modal,
  NumberInput,
  ProgressBar,
  Section,
  Stack,
  TextArea,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

const MAP_WIDTH = 5000;
const MAP_HEIGHT = 5000;
const NODE_RADIUS = 14;
const HUB_RADIUS = 22;
const PATH_CURVE_STRENGTH = 0.18;
const DEFAULT_SCALE = 0.75;

/** Hardcoded, free FontAwesome icon per station type (see trainstation defines). */
const STATION_TYPE_ICONS: Record<string, string> = {
  Cargo: 'box',
  Emergency: 'truck-medical',
  Military: 'shield-halved',
  City: 'city',
};

function getStationIcon(stationType: string): string {
  return STATION_TYPE_ICONS[stationType] || 'location-dot';
}

export interface TrainMapObject {
  id: string;
  station_ref?: string;
  name: string;
  desc: string;
  region: string;
  x: number;
  y: number;
  is_current: BooleanLike;
  is_next: BooleanLike;
  visited: number;
  is_local_center: BooleanLike;
  station_type: string;
}

export interface TrainMapPath {
  start_x: number;
  start_y: number;
  end_x: number;
  end_y: number;
}

export interface TrainPosition {
  x: number;
  y: number;
  angle: number;
  moving?: BooleanLike;
  progress?: number;
  from_x?: number;
  from_y?: number;
  to_x?: number;
  to_y?: number;
}

export interface MapData {
  objects: TrainMapObject[];
  paths: TrainMapPath[];
  train: TrainPosition;
}

export interface PossibleNextStation {
  name: string;
  type: string;
}

export interface AdminStation {
  name: string;
  type: string;
  loaded: BooleanLike;
}

export interface EditableStation {
  ref: string;
  name: string;
  desc: string;
  creator: string;
  region: string;
  station_type: string;
  threat_level: string;
  required_password: BooleanLike;
  required_stations: number;
  maximum_visits_unlimited: BooleanLike;
  maximum_visits: number;
  visible: BooleanLike;
  station_flags: number;
  is_custom: BooleanLike;
  connections: string[];
  nearstations: string[];
}

export interface NearStationOption {
  ref: string;
  name: string;
}

const REGION_OPTIONS = ['None', 'Thundra', 'Temperate', 'Desert'];
const TYPE_OPTIONS = ['unknown', 'Cargo', 'Emergency', 'Military', 'City'];
const THREAT_OPTIONS = ['Safe', 'Risky', 'Dangerous', 'Hazardous', 'Deadly'];

/** Station flag bits, mirroring fenysha_events/code/__DEFINES/trainstation.dm. */
const STATION_FLAGS: { label: string; bit: number }[] = [
  { label: 'Abstract', bit: 1 << 1 },
  { label: 'No Forks', bit: 1 << 2 },
  { label: 'Blocking', bit: 1 << 3 },
  { label: 'No Selection', bit: 1 << 4 },
  { label: 'No Near-station', bit: 1 << 5 },
  { label: 'No Spawning', bit: 1 << 6 },
  { label: 'Local Center', bit: 1 << 7 },
  { label: 'Start Station', bit: 1 << 8 },
  { label: 'Final Station', bit: 1 << 9 },
];

export interface TrainControlData {
  read_only: BooleanLike;
  admin_mode: BooleanLike;
  is_blocked: BooleanLike;
  is_moving: BooleanLike;
  train_engine_active: BooleanLike;
  current_station: string;
  planned_station: string;
  progress: number;
  time_remaining: number;
  speed_kmh: number;
  possible_next: PossibleNextStation[];
  all_stations?: AdminStation[];
  editable_stations?: EditableStation[];
  nearstation_options?: NearStationOption[];
  map_data: MapData;
}

/** Local position overrides keyed by object id while/after an admin drags a node. */
type PositionOverrides = Record<string, { x: number; y: number }>;

function clamp(v: number, lo: number, hi: number): number {
  return Math.max(lo, Math.min(hi, v));
}

/** Deciseconds (BYOND time) → "Xm Ys" (or just "Ys" under a minute). */
function formatEta(deciseconds: number): string {
  const total = Math.max(0, Math.ceil(deciseconds / 10));
  const minutes = Math.floor(total / 60);
  const seconds = total % 60;
  return minutes > 0 ? `${minutes}m ${seconds}s` : `${seconds}s`;
}

/** Region color (stable hash) */
function getRegionColor(region: string): string {
  let hash = 0;
  for (let i = 0; i < region.length; i++) {
    hash = region.charCodeAt(i) + ((hash << 5) - hash);
  }
  const hue = Math.abs(hash) % 360;
  return `hsl(${hue}, 70%, 52%)`;
}

/** Path kink point (metro style) */
function getPathKinkPoint(
  startX: number,
  startY: number,
  endX: number,
  endY: number,
  kinkRatio: number = 0.42,
): { cx: number; cy: number } {
  const dx = endX - startX;
  const dy = endY - startY;
  const len = Math.sqrt(dx * dx + dy * dy) || 1;

  const px = startX + dx * kinkRatio;
  const py = startY + dy * kinkRatio;

  const perpX = -dy / len;
  const perpY = dx / len;

  const bend = len * PATH_CURVE_STRENGTH;

  return {
    cx: px + perpX * bend,
    cy: py + perpY * bend,
  };
}

type LegGeometry = {
  fromX: number;
  fromY: number;
  toX: number;
  toY: number;
};

type TrainTarget = {
  x: number;
  y: number;
  angle: number; // radians
  leg: LegGeometry | null;
  progress: number;
};

function getLeg(train?: TrainPosition): LegGeometry | null {
  if (
    train?.moving &&
    train.from_x != null &&
    train.from_y != null &&
    train.to_x != null &&
    train.to_y != null
  ) {
    return {
      fromX: train.from_x,
      fromY: train.from_y,
      toX: train.to_x,
      toY: train.to_y,
    };
  }
  return null;
}

/** Position + tangent at `progress` along the kinked rail from→kink→to. */
function pointOnLeg(
  leg: LegGeometry,
  progress: number,
): { x: number; y: number; angle: number } {
  const { cx, cy } = getPathKinkPoint(leg.fromX, leg.fromY, leg.toX, leg.toY);
  const l1 = Math.hypot(cx - leg.fromX, cy - leg.fromY);
  const l2 = Math.hypot(leg.toX - cx, leg.toY - cy);
  const total = l1 + l2 || 1;
  const d = clamp(progress, 0, 1) * total;
  if (d <= l1) {
    const t = l1 > 0 ? d / l1 : 0;
    return {
      x: leg.fromX + (cx - leg.fromX) * t,
      y: leg.fromY + (cy - leg.fromY) * t,
      angle: Math.atan2(cy - leg.fromY, cx - leg.fromX),
    };
  }
  const t = l2 > 0 ? (d - l1) / l2 : 0;
  return {
    x: cx + (leg.toX - cx) * t,
    y: cy + (leg.toY - cy) * t,
    angle: Math.atan2(leg.toY - cy, leg.toX - cx),
  };
}

/** Where the train should render: on the rail when moving, else at its node. */
function getTrainTarget(train?: TrainPosition): TrainTarget {
  const leg = getLeg(train);
  if (leg) {
    const progress = train?.progress ?? 0;
    const p = pointOnLeg(leg, progress);
    return { x: p.x, y: p.y, angle: p.angle, leg, progress };
  }
  return {
    x: train?.x ?? 500,
    y: train?.y ?? 500,
    angle: ((train?.angle ?? 0) * Math.PI) / 180,
    leg: null,
    progress: 0,
  };
}

function lerpAngle(a: number, b: number, t: number): number {
  let d = b - a;
  while (d > Math.PI) d -= 2 * Math.PI;
  while (d < -Math.PI) d += 2 * Math.PI;
  return a + d * t;
}

function roundRectPath(
  ctx: CanvasRenderingContext2D,
  x: number,
  y: number,
  w: number,
  h: number,
  r: number,
) {
  ctx.beginPath();
  ctx.moveTo(x + r, y);
  ctx.arcTo(x + w, y, x + w, y + h, r);
  ctx.arcTo(x + w, y + h, x, y + h, r);
  ctx.arcTo(x, y + h, x, y, r);
  ctx.arcTo(x, y, x + w, y, r);
  ctx.closePath();
}

type AnimState = {
  pos: { x: number; y: number; angle: number };
  progress: number;
  moving: boolean;
  leg: LegGeometry | null;
  dash: number;
  pulse: number;
  lastT: number;
  initialized: boolean;
};

type CanvasFrameState = {
  map_data: MapData;
  scale: number;
  offsetX: number;
  offsetY: number;
  canvasSize: { width: number; height: number };
  nextStation: string;
  timeRemaining: number;
  speedKmh: number;
};

type TrainMapCanvasProps = {
  map_data: MapData;
  scale: number;
  offsetX: number;
  offsetY: number;
  nextStation: string;
  timeRemaining: number;
  speedKmh: number;
  /** Station-node layer, rendered between the background and the train. */
  overlay: ReactNode;
  onZoom: (newScale: number, newOffsetX: number, newOffsetY: number) => void;
  onDragStart: (clientX: number, clientY: number) => void;
};

export const TrainMapCanvas = (props: TrainMapCanvasProps) => {
  const { onZoom, onDragStart } = props;
  const containerRef = useRef<HTMLDivElement>(null);
  const bgCanvasRef = useRef<HTMLCanvasElement>(null);
  const fgCanvasRef = useRef<HTMLCanvasElement>(null);
  const [canvasSize, setCanvasSize] = useState({
    width: MAP_WIDTH,
    height: MAP_HEIGHT,
  });
  const [isDragging, setIsDragging] = useState(false);

  // Latest props for the animation loop, refreshed every render.
  const frameRef = useRef<CanvasFrameState>({
    map_data: props.map_data,
    scale: props.scale,
    offsetX: props.offsetX,
    offsetY: props.offsetY,
    canvasSize,
    nextStation: props.nextStation,
    timeRemaining: props.timeRemaining,
    speedKmh: props.speedKmh,
  });
  frameRef.current = {
    map_data: props.map_data,
    scale: props.scale,
    offsetX: props.offsetX,
    offsetY: props.offsetY,
    canvasSize,
    nextStation: props.nextStation,
    timeRemaining: props.timeRemaining,
    speedKmh: props.speedKmh,
  };

  const animRef = useRef<AnimState>({
    pos: { x: 500, y: 500, angle: 0 },
    progress: 0,
    moving: false,
    leg: null,
    dash: 0,
    pulse: 0,
    lastT: 0,
    initialized: false,
  });

  useEffect(() => {
    const updateSize = () => {
      if (containerRef.current) {
        const { width, height } = containerRef.current.getBoundingClientRect();
        setCanvasSize({ width: Math.round(width), height: Math.round(height) });
      }
    };
    updateSize();
    window.addEventListener('resize', updateSize);
    return () => window.removeEventListener('resize', updateSize);
  }, []);

  useEffect(() => {
    for (const ref of [bgCanvasRef, fgCanvasRef]) {
      const canvas = ref.current;
      if (canvas) {
        canvas.width = canvasSize.width;
        canvas.height = canvasSize.height;
      }
    }
  }, [canvasSize]);

  // ─── Animation update ──────────────────────────────────────────────────
  const update = (a: AnimState, dt: number, s: CanvasFrameState) => {
    const target = getTrainTarget(s.map_data.train);

    if (!a.initialized) {
      a.pos = { x: target.x, y: target.y, angle: target.angle };
      a.progress = target.progress;
      a.initialized = true;
    }

    if (target.leg) {
      a.moving = true;
      a.leg = target.leg;
      // Ease the leg progress so the train glides between backend ticks.
      a.progress += (target.progress - a.progress) * Math.min(1, dt * 2.5);
      if (Math.abs(target.progress - a.progress) < 0.0005)
        a.progress = target.progress;
      const p = pointOnLeg(target.leg, a.progress);
      a.pos.x = p.x;
      a.pos.y = p.y;
      a.pos.angle = lerpAngle(a.pos.angle, p.angle, Math.min(1, dt * 6));
    } else {
      a.moving = false;
      a.leg = null;
      a.progress = target.progress;
      const k = Math.min(1, dt * 4);
      a.pos.x += (target.x - a.pos.x) * k;
      a.pos.y += (target.y - a.pos.y) * k;
      a.pos.angle = lerpAngle(a.pos.angle, target.angle, k);
    }

    a.dash += dt * 40;
    a.pulse += dt;
  };

  // ─── Drawing ───────────────────────────────────────────────────────────
  // Background layer: grid, rails, active leg, station pulses. Drawn beneath
  // the DOM station nodes.
  const drawBackground = (
    canvas: HTMLCanvasElement,
    s: CanvasFrameState,
    a: AnimState,
  ) => {
    const ctx = canvas.getContext('2d');
    if (!ctx) return;
    const { scale, offsetX, offsetY } = s;
    const W = canvas.width;
    const H = canvas.height;

    ctx.clearRect(0, 0, W, H);
    ctx.save();
    ctx.translate(offsetX, offsetY);
    ctx.scale(scale, scale);

    // Grid (only the visible range, for performance)
    const viewL = clamp(-offsetX / scale, 0, MAP_WIDTH);
    const viewT = clamp(-offsetY / scale, 0, MAP_HEIGHT);
    const viewR = clamp((W - offsetX) / scale, 0, MAP_WIDTH);
    const viewB = clamp((H - offsetY) / scale, 0, MAP_HEIGHT);
    const drawGrid = (step: number, style: string) => {
      ctx.strokeStyle = style;
      ctx.lineWidth = 1 / scale;
      ctx.beginPath();
      for (let x = Math.floor(viewL / step) * step; x <= viewR; x += step) {
        ctx.moveTo(x, viewT);
        ctx.lineTo(x, viewB);
      }
      for (let y = Math.floor(viewT / step) * step; y <= viewB; y += step) {
        ctx.moveTo(viewL, y);
        ctx.lineTo(viewR, y);
      }
      ctx.stroke();
    };
    drawGrid(20, 'rgba(60, 80, 120, 0.18)');
    drawGrid(100, 'rgba(80, 100, 140, 0.35)');

    // Rails (dimmed while moving so the active leg stands out)
    const railAlpha = a.moving ? 0.4 : 1;
    for (const path of s.map_data.paths) {
      const { cx, cy } = getPathKinkPoint(
        path.start_x,
        path.start_y,
        path.end_x,
        path.end_y,
      );
      const railGap = Math.max(1.5, 4.5 / scale);
      const railWidth = Math.max(1, 2.4 / scale);
      const dx = path.end_x - path.start_x;
      const dy = path.end_y - path.start_y;
      const len = Math.hypot(dx, dy) || 1;
      const perpX = -dy / len;
      const perpY = dx / len;

      ctx.strokeStyle = `rgba(70, 80, 110, ${railAlpha})`;
      ctx.lineWidth = railWidth;
      ctx.lineCap = 'round';

      ctx.beginPath();
      ctx.moveTo(path.start_x + perpX * railGap, path.start_y + perpY * railGap);
      ctx.lineTo(cx + perpX * railGap, cy + perpY * railGap);
      ctx.lineTo(path.end_x + perpX * railGap, path.end_y + perpY * railGap);
      ctx.stroke();

      ctx.beginPath();
      ctx.moveTo(path.start_x - perpX * railGap, path.start_y - perpY * railGap);
      ctx.lineTo(cx - perpX * railGap, cy - perpY * railGap);
      ctx.lineTo(path.end_x - perpX * railGap, path.end_y - perpY * railGap);
      ctx.stroke();
    }

    // Active leg highlight (marching ants)
    if (a.leg) {
      const { cx, cy } = getPathKinkPoint(
        a.leg.fromX,
        a.leg.fromY,
        a.leg.toX,
        a.leg.toY,
      );
      ctx.save();
      ctx.strokeStyle = 'rgba(241, 196, 15, 0.95)';
      ctx.lineWidth = Math.max(1.5, 3.5 / scale);
      ctx.lineCap = 'round';
      ctx.setLineDash([10 / scale, 8 / scale]);
      ctx.lineDashOffset = -a.dash / scale;
      ctx.beginPath();
      ctx.moveTo(a.leg.fromX, a.leg.fromY);
      ctx.lineTo(cx, cy);
      ctx.lineTo(a.leg.toX, a.leg.toY);
      ctx.stroke();
      ctx.restore();
    }

    // Station pulses for current/destination
    for (const obj of s.map_data.objects) {
      const isCur = !!obj.is_current;
      const isNxt = !!obj.is_next;
      if (!isCur && !isNxt) continue;
      const base = obj.is_local_center ? HUB_RADIUS : NODE_RADIUS;
      const phase = (a.pulse * (isNxt ? 1.2 : 0.9)) % 1;
      ctx.globalAlpha = (1 - phase) * 0.6;
      ctx.strokeStyle = isCur ? '#27ae60' : '#f1c40f';
      ctx.lineWidth = 2 / scale;
      ctx.beginPath();
      ctx.arc(obj.x, obj.y, base + phase * 24, 0, Math.PI * 2);
      ctx.stroke();
      ctx.globalAlpha = 1;
    }

    ctx.restore();
  };

  // Foreground layer: the train (steam, consist, locomotive) and screen-space
  // tags. Drawn above the DOM station nodes so the train is never hidden.
  const drawForeground = (
    canvas: HTMLCanvasElement,
    s: CanvasFrameState,
    a: AnimState,
  ) => {
    const ctx = canvas.getContext('2d');
    if (!ctx) return;
    const { scale, offsetX, offsetY } = s;
    const W = canvas.width;
    const H = canvas.height;

    ctx.clearRect(0, 0, W, H);
    ctx.save();
    ctx.translate(offsetX, offsetY);
    ctx.scale(scale, scale);

    // Train marker: a simple directional arrow pointing along the track.
    ctx.save();
    ctx.translate(a.pos.x, a.pos.y);
    ctx.rotate(a.pos.angle);
    ctx.shadowColor = 'rgba(90, 160, 240, 0.8)';
    ctx.shadowBlur = a.moving ? 14 : 6;
    ctx.fillStyle = '#eef2f7';
    ctx.beginPath();
    ctx.moveTo(18, 0);
    ctx.lineTo(-14, -13);
    ctx.lineTo(-6, 0);
    ctx.lineTo(-14, 13);
    ctx.closePath();
    ctx.fill();
    ctx.shadowBlur = 0;
    ctx.strokeStyle = '#1c2530';
    ctx.lineWidth = Math.max(1, 1.8 / scale);
    ctx.stroke();
    ctx.restore();

    ctx.restore();

    // ─── Screen-space overlays ───────────────────────────────────────────
    const sx = offsetX + a.pos.x * scale;
    const sy = offsetY + a.pos.y * scale;
    const margin = 26;
    const onScreen =
      sx >= margin && sx <= W - margin && sy >= margin && sy <= H - margin;

    if (a.moving && onScreen) {
      // Telemetry tag above the loco.
      const label = `${s.nextStation || '—'}   ~${formatEta(s.timeRemaining)}   ${s.speedKmh} km/h`;
      ctx.font = '12px sans-serif';
      const tw = ctx.measureText(label).width;
      const bx = clamp(sx - tw / 2 - 8, 4, W - tw - 20);
      const by = clamp(sy - 44, 4, H - 24);
      ctx.fillStyle = 'rgba(10, 14, 22, 0.85)';
      roundRectPath(ctx, bx, by, tw + 16, 20, 5);
      ctx.fill();
      ctx.strokeStyle = 'rgba(241, 196, 15, 0.6)';
      ctx.lineWidth = 1;
      roundRectPath(ctx, bx, by, tw + 16, 20, 5);
      ctx.stroke();
      ctx.fillStyle = '#f3e9c8';
      ctx.textBaseline = 'middle';
      ctx.fillText(label, bx + 8, by + 11);
    }

    if (!onScreen) {
      // Off-screen indicator pointing at the train.
      const cxs = W / 2;
      const cys = H / 2;
      const ang = Math.atan2(sy - cys, sx - cxs);
      const ex = clamp(sx, margin, W - margin);
      const ey = clamp(sy, margin, H - margin);
      ctx.save();
      ctx.translate(ex, ey);
      ctx.fillStyle = 'rgba(10, 14, 22, 0.85)';
      ctx.beginPath();
      ctx.arc(0, 0, 16, 0, Math.PI * 2);
      ctx.fill();
      ctx.strokeStyle = '#f1c40f';
      ctx.lineWidth = 2;
      ctx.stroke();
      ctx.rotate(ang);
      ctx.fillStyle = '#f1c40f';
      ctx.beginPath();
      ctx.moveTo(9, 0);
      ctx.lineTo(-1, -5);
      ctx.lineTo(-1, 5);
      ctx.closePath();
      ctx.fill();
      ctx.restore();
      if (a.moving) {
        ctx.font = '11px sans-serif';
        ctx.fillStyle = '#f3e9c8';
        ctx.textBaseline = 'middle';
        ctx.fillText(`Train ~${formatEta(s.timeRemaining)}`, ex + 20, ey);
      }
    }
  };

  // ─── rAF loop ──────────────────────────────────────────────────────────
  useEffect(() => {
    let raf = 0;
    const frame = (t: number) => {
      const a = animRef.current;
      const dt = a.lastT ? Math.min(0.05, (t - a.lastT) / 1000) : 0.016;
      a.lastT = t;
      update(a, dt, frameRef.current);
      if (bgCanvasRef.current)
        drawBackground(bgCanvasRef.current, frameRef.current, a);
      if (fgCanvasRef.current)
        drawForeground(fgCanvasRef.current, frameRef.current, a);
      raf = requestAnimationFrame(frame);
    };
    raf = requestAnimationFrame(frame);
    return () => cancelAnimationFrame(raf);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const handleWheel = (e: React.WheelEvent<HTMLCanvasElement>) => {
    e.preventDefault();
    const canvas = bgCanvasRef.current;
    if (!canvas) return;
    const rect = canvas.getBoundingClientRect();
    const mouseX = e.clientX - rect.left;
    const mouseY = e.clientY - rect.top;
    const factor = e.deltaY > 0 ? 0.92 : 1 / 0.92;
    const { scale, offsetX, offsetY } = props;
    const newScale = Math.max(0.25, Math.min(4, scale * factor));
    // Keep the world point under the cursor pinned while zooming.
    const newOffsetX = mouseX - ((mouseX - offsetX) / scale) * newScale;
    const newOffsetY = mouseY - ((mouseY - offsetY) / scale) * newScale;
    onZoom(newScale, newOffsetX, newOffsetY);
  };

  return (
    <div
      ref={containerRef}
      style={{
        width: '100%',
        height: '100%',
        position: 'relative',
        overflow: 'hidden',
        background: 'linear-gradient(160deg, #1a1f2e 0%, #0f1219 100%)',
        borderRadius: '8px',
      }}
    >
      <canvas
        ref={bgCanvasRef}
        style={{
          position: 'absolute',
          inset: 0,
          cursor: isDragging ? 'grabbing' : 'grab',
          touchAction: 'none',
        }}
        onMouseDown={(e) => {
          if (e.button === 0) {
            setIsDragging(true);
            onDragStart(e.clientX, e.clientY);
          }
        }}
        onMouseUp={() => setIsDragging(false)}
        onMouseLeave={() => setIsDragging(false)}
        onWheel={handleWheel}
      />
      {props.overlay}
      <canvas
        ref={fgCanvasRef}
        style={{ position: 'absolute', inset: 0, pointerEvents: 'none' }}
      />
    </div>
  );
};

function getStationColor(station: TrainMapObject): string {
  switch (station.region) {
    case 'Cargo':
      return '#f1c40f';
    case 'Emergency':
      return '#f1c40f';
    case 'Military':
      return '#27ae60';
    case 'City':
      return '#f1c40f';
    default:
      return getRegionColor(station.region);
  }
}

type StationNodeProps = {
  obj: TrainMapObject;
  posX: number;
  posY: number;
  scale: number;
  isSelected: boolean;
  admin: boolean;
  onClick: () => void;
  onDragStart: (id: string, clientX: number, clientY: number) => void;
};

const StationNode = (props: StationNodeProps) => {
  const { obj, posX, posY, scale, isSelected, admin, onClick, onDragStart } =
    props;
  const isCur = !!obj.is_current;
  const isNxt = !!obj.is_next;
  const isLocal = !!obj.is_local_center;
  const radius = isLocal ? HUB_RADIUS : NODE_RADIUS;
  const color = isCur
    ? '#27ae60'
    : isNxt
      ? '#f1c40f'
      : getStationColor(props.obj);

  const showLabel = scale > 0.5 || isLocal;
  const labelSize = isLocal ? 12 : 10;
  const strokeWidth = Math.max(1.5, 3.5 / scale);
  const stationIcon = getStationIcon(obj.station_type);

  return (
    <Box
      style={{
        position: 'absolute',
        left: posX,
        top: posY,
        width: 0,
        height: 0,
        transform: 'translate(-50%, -50%)',
        pointerEvents: 'auto',
        cursor: admin ? 'move' : 'pointer',
        zIndex: isCur || isNxt || isSelected ? 20 : 10,
      }}
      onClick={(e) => {
        e.stopPropagation();
        onClick();
      }}
      onMouseDown={(e) => {
        if (!admin || e.button !== 0) return;
        // Take over the gesture so the canvas doesn't start panning.
        e.stopPropagation();
        onDragStart(obj.id, e.clientX, e.clientY);
      }}
    >
      {showLabel && (
        <Box
          style={{
            position: 'absolute',
            left: '50%',
            bottom: '100%',
            transform: 'translate(-50%, -6px)',
            whiteSpace: 'nowrap',
            fontSize: `${labelSize}px`,
            fontWeight: isLocal ? 700 : 500,
            color: '#e8e8e8',
            textShadow: '0 1px 2px rgba(0,0,0,0.8)',
            pointerEvents: 'none',
            userSelect: 'none',
          }}
        >
          {obj.name}
          {isLocal ? ' ★' : ''}
        </Box>
      )}
      <Box
        style={{
          width: radius * 2,
          height: radius * 2,
          marginLeft: -radius,
          marginTop: -radius,
          borderRadius: '50%',
          backgroundColor: color,
          boxShadow: `0 0 0 ${strokeWidth}px ${isLocal ? '#fff' : 'rgba(255,255,255,0.4)'}, 0 2px 8px rgba(0,0,0,0.4)`,
          border:
            isSelected || isCur || isNxt
              ? `${Math.max(2, 4 / scale)}px solid #fff`
              : 'none',
        }}
      />
      <Box
        style={{
          position: 'absolute',
          left: 0,
          top: 0,
          transform: 'translate(-50%, -50%)',
          fontSize: `${radius * 1.05}px`,
          lineHeight: 1,
          color: '#10131a',
          pointerEvents: 'none',
          userSelect: 'none',
        }}
      >
        <Icon name={stationIcon} />
      </Box>
    </Box>
  );
};

type StationsOverlayProps = {
  map_data: MapData;
  overrides: PositionOverrides;
  scale: number;
  offsetX: number;
  offsetY: number;
  selectedId: string | null;
  admin: boolean;
  onSelect: (id: string) => void;
  onNodeDragStart: (id: string, clientX: number, clientY: number) => void;
};

const StationsOverlay = (props: StationsOverlayProps) => {
  const {
    map_data,
    overrides,
    scale,
    offsetX,
    offsetY,
    selectedId,
    admin,
    onSelect,
    onNodeDragStart,
  } = props;
  return (
    <Box
      style={{
        position: 'absolute',
        left: 0,
        top: 0,
        width: MAP_WIDTH,
        height: MAP_HEIGHT,
        transform: `translate(${offsetX}px, ${offsetY}px) scale(${scale})`,
        transformOrigin: '0 0',
        pointerEvents: 'none',
      }}
    >
      {map_data.objects.map((obj) => {
        const override = overrides[obj.id];
        return (
          <StationNode
            key={obj.id}
            obj={obj}
            posX={override ? override.x : obj.x}
            posY={override ? override.y : obj.y}
            scale={scale}
            isSelected={obj.id === selectedId}
            admin={admin}
            onClick={() => onSelect(obj.id)}
            onDragStart={onNodeDragStart}
          />
        );
      })}
    </Box>
  );
};

type StatusPanelProps = {
  read_only: BooleanLike;
  is_moving: BooleanLike;
  station_blocked: BooleanLike;
  train_engine_active: BooleanLike;
  current_station: string;
  planned_station: string;
  progress: number;
  time_remaining: number;
  speed_kmh: number;
  onStart: () => void;
  onStop: () => void;
};

const StatusPanel = (props: StatusPanelProps) => {
  const canDepart =
    !!props.train_engine_active &&
    !props.is_moving &&
    !!props.planned_station &&
    !props.station_blocked;

  const getDepartReason = () => {
    if (!props.train_engine_active) return 'Train engine is not running';
    if (props.station_blocked) return 'Magnetic lock is engaged';
    if (props.is_moving) return 'Train is already moving';
    if (!props.planned_station) return 'No destination station selected';
    return '';
  };

  return (
    <Section title="Train Status">
      {/* Prominent speedometer */}
      <Box
        mb={1.5}
        p={1.5}
        style={{
          borderRadius: '6px',
          display: 'flex',
          alignItems: 'baseline',
          justifyContent: 'center',
          gap: '10px',
          border: `1px solid ${props.is_moving ? 'rgba(39,174,96,0.55)' : 'rgba(255,255,255,0.12)'}`,
          background: props.is_moving
            ? 'linear-gradient(135deg, rgba(39,174,96,0.28), rgba(20,30,24,0.55))'
            : 'rgba(255,255,255,0.04)',
        }}
      >
        <Icon
          name="gauge-high"
          size={1.8}
          color={props.is_moving ? 'good' : 'label'}
          style={{ alignSelf: 'center' }}
        />
        <Box
          color={props.is_moving ? 'good' : 'label'}
          style={{ fontSize: '32px', fontWeight: 700, lineHeight: 1 }}
        >
          {props.is_moving ? props.speed_kmh : 0}
        </Box>
        <Box color="label" style={{ fontSize: '15px' }}>
          km/h
        </Box>
      </Box>
      <LabeledList>
        <LabeledList.Item label="Current Station">
          {props.current_station || '—'}
        </LabeledList.Item>
        <LabeledList.Item label="Next Station">
          {props.planned_station || '—'}
        </LabeledList.Item>
        <LabeledList.Item label="Movement">
          <ProgressBar
            value={props.progress}
            color={props.is_moving ? 'good' : 'average'}
          >
            {props.is_moving
              ? `Arriving in ~${formatEta(props.time_remaining)}`
              : 'Stopped'}
          </ProgressBar>
        </LabeledList.Item>
      </LabeledList>

      {!!props.station_blocked && (
        <Box mt={1} color="bad" bold>
          Magnetic lock active — station is blocked
        </Box>
      )}

      {!props.read_only && (
        <Stack mt={2} justify="space-between">
          <Button
            icon="play"
            color="good"
            disabled={!canDepart}
            tooltip={canDepart ? undefined : getDepartReason()}
            onClick={canDepart ? props.onStart : undefined}
          >
            Depart Train
          </Button>

          <Button
            icon="stop"
            color="bad"
            disabled={!props.is_moving}
            tooltip={props.is_moving ? undefined : 'Train is not moving'}
            onClick={props.onStop}
          >
            Stop Train
          </Button>
        </Stack>
      )}

      {!props.read_only && !canDepart && (
        <Box
          mt={2}
          p={2}
          style={{
            backgroundColor: 'rgba(220, 0, 0, 0.2)',
            border: '1px solid #c00',
            borderRadius: '4px',
            color: '#ffdddd',
            textAlign: 'center',
          }}
        >
          <strong>Departure not possible:</strong>
          <br />
          {getDepartReason() || 'Check the train status'}
        </Box>
      )}
    </Section>
  );
};

type AdminPanelProps = {
  current_station: string;
  all_stations: AdminStation[];
  onForceStart: () => void;
  onForceStop: () => void;
  onUnload: () => void;
  onLoad: (type: string) => void;
  onCreateCargo: () => void;
  onVV: () => void;
};

const AdminPanel = (props: AdminPanelProps) => (
  <Section title="Admin Tools">
    <Box italic color="label" mb={1}>
      Drag any station node to reposition it on the map.
    </Box>
    <Stack mb={1} wrap>
      <Button icon="play" color="good" onClick={props.onForceStart}>
        Force Start
      </Button>
      <Button icon="stop" color="bad" onClick={props.onForceStop}>
        Force Stop
      </Button>
      <Button
        icon="eject"
        color="bad"
        disabled={!props.current_station}
        onClick={props.onUnload}
      >
        Unload
      </Button>
    </Stack>
    <Stack mb={1} wrap>
      <Button icon="box" color="teal" onClick={props.onCreateCargo}>
        Create Cargo Station
      </Button>
      <Button icon="bug" onClick={props.onVV}>
        VV
      </Button>
    </Stack>
    <Box bold mt={1} mb={0.5}>
      Force Load Station:
    </Box>
    <Box style={{ maxHeight: '180px', overflowY: 'auto' }}>
      {props.all_stations.length === 0 ? (
        <Box color="average">No stations registered.</Box>
      ) : (
        props.all_stations.map((st) => (
          <Button
            key={st.type}
            fluid
            icon="train"
            color={st.loaded ? 'good' : 'default'}
            onClick={() => props.onLoad(st.type)}
          >
            {st.name}
            {st.loaded ? ' (Loaded)' : ''}
          </Button>
        ))
      )}
    </Box>
  </Section>
);

type SelectedStationPanelProps = {
  selectedObject: TrainMapObject;
  possibleSet: Set<string>;
  is_moving: BooleanLike;
  read_only: BooleanLike;
  canEdit: boolean;
  onClose: () => void;
  onSetAsNext: () => void;
  onEdit: () => void;
};

const SelectedStationPanel = (props: SelectedStationPanelProps) => (
  <Section
    title={`Selected Station: ${props.selectedObject.name}`}
    buttons={
      <>
        {props.canEdit && (
          <Button icon="pen" color="teal" onClick={props.onEdit}>
            Edit
          </Button>
        )}
        <Button icon="times" color="transparent" onClick={props.onClose} />
      </>
    }
  >
    <LabeledList>
      <LabeledList.Item label="Region">
        {props.selectedObject.region}
      </LabeledList.Item>
      <LabeledList.Item
        label="Type"
        color={getStationColor(props.selectedObject)}
      >
        {props.selectedObject.station_type}
      </LabeledList.Item>
      <LabeledList.Item label="Visits">
        {props.selectedObject.visited} times
      </LabeledList.Item>
      <LabeledList.Item label="Description">
        {props.selectedObject.desc || 'No description available'}
      </LabeledList.Item>
    </LabeledList>
    {!props.read_only &&
      (() => {
        const base = props.selectedObject.id.split('#')[0];
        return props.possibleSet.has(base);
      })() &&
      !props.is_moving && (
        <Button
          mt={2}
          fluid
          icon="arrow-right"
          color="good"
          onClick={props.onSetAsNext}
        >
          Set as next station
        </Button>
      )}
  </Section>
);

type PossibleNextListProps = {
  possible_next: PossibleNextStation[];
  onChoose: (type: string) => void;
};

const PossibleNextList = (props: PossibleNextListProps) => (
  <Section title="Possible Destinations">
    {props.possible_next.map((st) => (
      <Button
        key={st.type}
        fluid
        mt={0.5}
        onClick={() => props.onChoose(st.type)}
      >
        → {st.name}
      </Button>
    ))}
  </Section>
);

type StationEditorModalProps = {
  station: EditableStation;
  allStations: EditableStation[];
  nearOptions: NearStationOption[];
  onSave: (draft: EditableStation) => void;
  onDelete: (ref: string) => void;
  onClose: () => void;
};

const StationEditorModal = (props: StationEditorModalProps) => {
  const { station, allStations, nearOptions, onSave, onDelete, onClose } = props;
  const [draft, setDraft] = useState<EditableStation>(() => ({
    ...station,
    connections: [...station.connections],
    nearstations: [...station.nearstations],
  }));
  const [confirmDelete, setConfirmDelete] = useState(false);

  const set = (patch: Partial<EditableStation>) =>
    setDraft((d) => ({ ...d, ...patch }));

  const refName = (ref: string) =>
    allStations.find((s) => s.ref === ref)?.name ?? 'Unknown station';

  // Build unique labels for the add-connection picker (names can repeat).
  const seen: Record<string, number> = {};
  const addable = allStations
    .filter((s) => s.ref !== draft.ref && !draft.connections.includes(s.ref))
    .map((s) => {
      seen[s.name] = (seen[s.name] || 0) + 1;
      const label = seen[s.name] > 1 ? `${s.name} (${seen[s.name]})` : s.name;
      return { label, ref: s.ref };
    });

  const toggleNear = (ref: string) =>
    set({
      nearstations: draft.nearstations.includes(ref)
        ? draft.nearstations.filter((r) => r !== ref)
        : [...draft.nearstations, ref],
    });

  return (
    <Modal>
      <Box width="560px">
        <Stack mb={1} align="center">
          <Stack.Item grow bold fontSize="14px">
            {station.is_custom ? '🛠 ' : ''}
            Edit Station: {draft.name || 'Unnamed'}
          </Stack.Item>
          <Stack.Item>
            <Button icon="times" color="transparent" onClick={onClose} />
          </Stack.Item>
        </Stack>

        <Box style={{ maxHeight: '440px', overflowY: 'auto', paddingRight: '6px' }}>
          <Section title="Variables">
            <LabeledList>
              <LabeledList.Item label="Name">
                <Input
                  fluid
                  value={draft.name}
                  onChange={(v) => set({ name: v })}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Description">
                <TextArea
                  height="48px"
                  fluid
                  value={draft.desc}
                  onChange={(v) => set({ desc: v })}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Creator">
                <Input
                  fluid
                  value={draft.creator}
                  onChange={(v) => set({ creator: v })}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Region">
                <Dropdown
                  selected={draft.region}
                  options={REGION_OPTIONS}
                  onSelected={(v) => set({ region: v })}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Station Type">
                <Dropdown
                  selected={draft.station_type}
                  options={TYPE_OPTIONS}
                  onSelected={(v) => set({ station_type: v })}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Threat Level">
                <Dropdown
                  selected={draft.threat_level}
                  options={THREAT_OPTIONS}
                  onSelected={(v) => set({ threat_level: v })}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Flags">
                <Button.Checkbox
                  checked={!!draft.visible}
                  onClick={() => set({ visible: draft.visible ? 0 : 1 })}
                >
                  Visible / selectable
                </Button.Checkbox>
                <Button.Checkbox
                  checked={!!draft.required_password}
                  onClick={() =>
                    set({ required_password: draft.required_password ? 0 : 1 })
                  }
                >
                  Requires password
                </Button.Checkbox>
              </LabeledList.Item>
              <LabeledList.Item label="Required Stations">
                <NumberInput
                  width="60px"
                  step={1}
                  minValue={0}
                  maxValue={999}
                  value={draft.required_stations}
                  onChange={(v) => set({ required_stations: v })}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Max Visits">
                <Button.Checkbox
                  checked={!!draft.maximum_visits_unlimited}
                  onClick={() =>
                    set({
                      maximum_visits_unlimited: draft.maximum_visits_unlimited
                        ? 0
                        : 1,
                    })
                  }
                >
                  Unlimited
                </Button.Checkbox>
                {!draft.maximum_visits_unlimited && (
                  <NumberInput
                    width="60px"
                    step={1}
                    minValue={1}
                    maxValue={999}
                    value={draft.maximum_visits}
                    onChange={(v) => set({ maximum_visits: v })}
                  />
                )}
              </LabeledList.Item>
            </LabeledList>
          </Section>

          <Section title="Station Flags">
            {STATION_FLAGS.map((f) => (
              <Button.Checkbox
                key={f.bit}
                checked={(draft.station_flags & f.bit) !== 0}
                onClick={() =>
                  set({ station_flags: draft.station_flags ^ f.bit })
                }
              >
                {f.label}
              </Button.Checkbox>
            ))}
          </Section>

          <Section title="Connected Stations">
            {draft.connections.length === 0 ? (
              <Box color="label" italic mb={1}>
                No connections.
              </Box>
            ) : (
              draft.connections.map((ref) => (
                <Box key={ref} mb={0.5}>
                  <Button
                    icon="times"
                    color="bad"
                    onClick={() =>
                      set({
                        connections: draft.connections.filter((r) => r !== ref),
                      })
                    }
                  />{' '}
                  {refName(ref)}
                </Box>
              ))
            )}
            {addable.length > 0 && (
              <Dropdown
                mt={1}
                width="100%"
                selected=""
                placeholder="Add connection..."
                options={addable.map((a) => a.label)}
                onSelected={(label) => {
                  const match = addable.find((a) => a.label === label);
                  if (match)
                    set({ connections: [...draft.connections, match.ref] });
                }}
              />
            )}
          </Section>

          <Section title="Surrounding (Near) Stations">
            {nearOptions.length === 0 ? (
              <Box color="label" italic>
                No near-station templates available.
              </Box>
            ) : (
              nearOptions.map((n) => (
                <Button.Checkbox
                  key={n.ref}
                  checked={draft.nearstations.includes(n.ref)}
                  onClick={() => toggleNear(n.ref)}
                >
                  {n.name}
                </Button.Checkbox>
              ))
            )}
          </Section>
        </Box>

        <Stack mt={1}>
          <Stack.Item grow>
            {confirmDelete ? (
              <Button
                icon="trash"
                color="bad"
                onClick={() => onDelete(draft.ref)}
              >
                Confirm delete
              </Button>
            ) : (
              <Button
                icon="trash"
                color="bad"
                onClick={() => setConfirmDelete(true)}
              >
                Delete Station
              </Button>
            )}
          </Stack.Item>
          <Stack.Item>
            <Button onClick={onClose}>Cancel</Button>
          </Stack.Item>
          <Stack.Item>
            <Button icon="save" color="good" onClick={() => onSave(draft)}>
              Save
            </Button>
          </Stack.Item>
        </Stack>
      </Box>
    </Modal>
  );
};

export const TrainControlTerminal = () => {
  const { act, data } = useBackend<TrainControlData>();
  const {
    read_only,
    admin_mode,
    is_blocked,
    is_moving,
    train_engine_active,
    current_station,
    planned_station,
    progress,
    time_remaining,
    speed_kmh = 0,
    possible_next = [],
    all_stations = [],
    editable_stations = [],
    nearstation_options = [],
    map_data = { objects: [], paths: [], train: { x: 500, y: 500, angle: 0 } },
  } = data;

  const isAdmin = !!admin_mode;

  const [editingRef, setEditingRef] = useState<string | null>(null);
  const [pendingCreate, setPendingCreate] = useState(false);
  const prevRefsRef = useRef<Set<string>>(new Set());
  const editingStation = editable_stations.find((s) => s.ref === editingRef);

  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [scale, setScale] = useState(DEFAULT_SCALE);
  const [offsetX, setOffsetX] = useState(80);
  const [offsetY, setOffsetY] = useState(80);
  const [dragStart, setDragStart] = useState({ x: 0, y: 0 });
  const [overrides, setOverrides] = useState<PositionOverrides>({});
  const [followTrain, setFollowTrain] = useState(false);

  const viewportRef = useRef<HTMLDivElement>(null);
  const [viewport, setViewport] = useState({ width: 0, height: 0 });
  const didInitView = useRef(false);

  // Active node drag (admin). In a ref so the mousemove handler stays stable.
  const nodeDragRef = useRef<{
    id: string;
    startX: number;
    startY: number;
    originX: number;
    originY: number;
  } | null>(null);
  const [nodeDragging, setNodeDragging] = useState(false);

  const possibleSet = new Set(possible_next.map((s) => s.type));
  const selectedObject = map_data.objects.find((o) => o.id === selectedId);

  // Track the viewport size so we can center on the train precisely.
  useEffect(() => {
    const el = viewportRef.current;
    if (!el) return;
    const measure = () => {
      const rect = el.getBoundingClientRect();
      setViewport({ width: rect.width, height: rect.height });
    };
    measure();
    const observer = new ResizeObserver(measure);
    observer.observe(el);
    return () => observer.disconnect();
  }, []);

  const centerOnTrain = useCallback(
    (targetScale: number = DEFAULT_SCALE) => {
      const t = getTrainTarget(map_data.train);
      const w = viewport.width || 800;
      const h = viewport.height || 600;
      setScale(targetScale);
      setOffsetX(w / 2 - t.x * targetScale);
      setOffsetY(h / 2 - t.y * targetScale);
    },
    [map_data.train, viewport.width, viewport.height],
  );

  // Auto-center on the train the first time we know the viewport size.
  useEffect(() => {
    if (didInitView.current) return;
    if (viewport.width > 0 && viewport.height > 0) {
      didInitView.current = true;
      centerOnTrain();
    }
  }, [viewport.width, viewport.height, centerOnTrain]);

  // Follow-cam: keep the train centered as it moves.
  useEffect(() => {
    if (!followTrain) return;
    const t = getTrainTarget(map_data.train);
    const w = viewport.width || 800;
    const h = viewport.height || 600;
    setOffsetX(w / 2 - t.x * scale);
    setOffsetY(h / 2 - t.y * scale);
  }, [followTrain, map_data.train, scale, viewport.width, viewport.height]);

  const handleZoom = (
    newScale: number,
    newOffsetX: number,
    newOffsetY: number,
  ) => {
    setScale(newScale);
    setOffsetX(newOffsetX);
    setOffsetY(newOffsetY);
  };

  const handleDragStart = (clientX: number, clientY: number) => {
    if (followTrain) setFollowTrain(false); // manual pan releases follow-cam
    setDragStart({ x: clientX - offsetX, y: clientY - offsetY });
  };

  const handleMouseMove = useCallback(
    (e: MouseEvent) => {
      if (dragStart.x === 0 && dragStart.y === 0) return;
      setOffsetX(e.clientX - dragStart.x);
      setOffsetY(e.clientY - dragStart.y);
    },
    [dragStart],
  );

  const handleMouseUp = useCallback(() => setDragStart({ x: 0, y: 0 }), []);

  useEffect(() => {
    if (dragStart.x !== 0 || dragStart.y !== 0) {
      window.addEventListener('mousemove', handleMouseMove);
      window.addEventListener('mouseup', handleMouseUp);
      return () => {
        window.removeEventListener('mousemove', handleMouseMove);
        window.removeEventListener('mouseup', handleMouseUp);
      };
    }
  }, [dragStart, handleMouseMove, handleMouseUp]);

  // Translate cursor movement to map coords; override tracks it until committed.
  const onNodeDragStart = useCallback(
    (id: string, clientX: number, clientY: number) => {
      if (!isAdmin) return;
      const obj = map_data.objects.find((o) => o.id === id);
      if (!obj) return;
      const start = overrides[id] ?? { x: obj.x, y: obj.y };
      nodeDragRef.current = {
        id,
        startX: clientX,
        startY: clientY,
        originX: start.x,
        originY: start.y,
      };
      setNodeDragging(true);
      setSelectedId(id);
    },
    [isAdmin, map_data.objects, overrides],
  );

  useEffect(() => {
    if (!nodeDragging) return;
    const onMove = (e: MouseEvent) => {
      const drag = nodeDragRef.current;
      if (!drag) return;
      const dxWorld = (e.clientX - drag.startX) / scale;
      const dyWorld = (e.clientY - drag.startY) / scale;
      setOverrides((prev) => ({
        ...prev,
        [drag.id]: {
          x: Math.round(drag.originX + dxWorld),
          y: Math.round(drag.originY + dyWorld),
        },
      }));
    };
    const onUp = () => {
      const drag = nodeDragRef.current;
      if (drag) {
        setOverrides((prev) => {
          const pos = prev[drag.id];
          if (pos) {
            act('move_object', { id: drag.id, x: pos.x, y: pos.y });
          }
          return prev;
        });
      }
      nodeDragRef.current = null;
      setNodeDragging(false);
    };
    window.addEventListener('mousemove', onMove);
    window.addEventListener('mouseup', onUp);
    return () => {
      window.removeEventListener('mousemove', onMove);
      window.removeEventListener('mouseup', onUp);
    };
  }, [nodeDragging, scale, act]);

  // Drop the override once the backend catches up to the dragged position.
  useEffect(() => {
    if (nodeDragging) return;
    setOverrides((prev) => {
      if (Object.keys(prev).length === 0) return prev;
      const next: PositionOverrides = {};
      let changed = false;
      for (const id of Object.keys(prev)) {
        const obj = map_data.objects.find((o) => o.id === id);
        if (
          obj &&
          Math.abs(obj.x - prev[id].x) <= 1 &&
          Math.abs(obj.y - prev[id].y) <= 1
        ) {
          changed = true; // settled - drop it
        } else {
          next[id] = prev[id];
        }
      }
      return changed ? next : prev;
    });
  }, [map_data.objects, nodeDragging]);

  const resetView = () => {
    centerOnTrain();
    setSelectedId(null);
  };

  // Zoom by a factor, keeping the viewport center pinned (used by +/- buttons).
  const zoomAtCenter = (factor: number) => {
    const px = (viewport.width || 800) / 2;
    const py = (viewport.height || 600) / 2;
    const newScale = Math.max(0.25, Math.min(4, scale * factor));
    setOffsetX(px - ((px - offsetX) / scale) * newScale);
    setOffsetY(py - ((py - offsetY) / scale) * newScale);
    setScale(newScale);
  };

  const setAsNext = () => {
    if (!selectedObject) return;
    const base = selectedObject.id.split('#')[0];
    if (!possibleSet.has(base)) return;
    act('choose_next', { station_type: selectedObject.id });
    setSelectedId(null);
  };

  // After a create finishes (it's async on the server), open the editor for the
  // station that newly appeared.
  useEffect(() => {
    const cur = new Set(editable_stations.map((s) => s.ref));
    if (pendingCreate) {
      for (const ref of cur) {
        if (!prevRefsRef.current.has(ref)) {
          setEditingRef(ref);
          setPendingCreate(false);
          break;
        }
      }
    }
    prevRefsRef.current = cur;
  }, [editable_stations, pendingCreate]);

  const createCargoStation = () => {
    // Spawn at the world point currently under the viewport center.
    const worldX = ((viewport.width || 800) / 2 - offsetX) / scale;
    const worldY = ((viewport.height || 600) / 2 - offsetY) / scale;
    act('create_cargo_station', {
      x: Math.round(worldX),
      y: Math.round(worldY),
    });
    setPendingCreate(true);
  };

  const saveStation = (draft: EditableStation) => {
    act('save_station', {
      ref: draft.ref,
      name: draft.name,
      desc: draft.desc,
      creator: draft.creator,
      region: draft.region,
      station_type: draft.station_type,
      threat_level: draft.threat_level,
      required_password: draft.required_password ? 1 : 0,
      visible: draft.visible ? 1 : 0,
      required_stations: draft.required_stations,
      maximum_visits_unlimited: draft.maximum_visits_unlimited ? 1 : 0,
      maximum_visits: draft.maximum_visits,
      station_flags: draft.station_flags,
      connections: draft.connections,
      nearstations: draft.nearstations,
    });
    setEditingRef(null);
  };

  const deleteStation = (ref: string) => {
    act('delete_station', { ref });
    setEditingRef(null);
  };

  const editSelectedStation = () => {
    const ref = selectedObject?.station_ref;
    if (ref && editable_stations.some((s) => s.ref === ref)) {
      setEditingRef(ref);
    }
  };

  return (
    <Window
      title={isAdmin ? 'Train Controller (Admin)' : 'Train Control Panel'}
      width={1280}
      height={720}
    >
      <Window.Content
        style={{
          background: 'linear-gradient(180deg, #1e2433 0%, #151a24 100%)',
        }}
      >
        <Stack height="100%" direction="row" fill>
          <Stack.Item grow={1} style={{ position: 'relative', minHeight: 0 }}>
            <div
              ref={viewportRef}
              style={{
                position: 'relative',
                width: '100%',
                height: '100%',
                overflow: 'hidden',
              }}
            >
              <TrainMapCanvas
                map_data={map_data}
                scale={scale}
                offsetX={offsetX}
                offsetY={offsetY}
                nextStation={planned_station}
                timeRemaining={time_remaining}
                speedKmh={speed_kmh}
                onZoom={handleZoom}
                onDragStart={handleDragStart}
                overlay={
                  <StationsOverlay
                    map_data={map_data}
                    overrides={overrides}
                    scale={scale}
                    offsetX={offsetX}
                    offsetY={offsetY}
                    selectedId={selectedId}
                    admin={isAdmin}
                    onSelect={setSelectedId}
                    onNodeDragStart={onNodeDragStart}
                  />
                }
              />
            </div>

            {/* View control panel */}
            <Box
              position="absolute"
              top="10px"
              left="10px"
              backgroundColor="rgba(0,0,0,0.75)"
              p={1}
              style={{
                borderRadius: '6px',
                zIndex: 30,
                display: 'flex',
                gap: '6px',
                flexWrap: 'wrap',
              }}
            >
              <Button icon="crosshairs" onClick={resetView}>
                Center on Train
              </Button>
              <Button
                icon="video"
                selected={followTrain}
                tooltip="Keep the camera locked on the train"
                onClick={() => setFollowTrain((f) => !f)}
              >
                Follow
              </Button>
              <Button icon="plus" onClick={() => zoomAtCenter(1.25)} />
              <Button icon="minus" onClick={() => zoomAtCenter(0.8)} />
            </Box>

            <Box
              position="absolute"
              bottom="10px"
              left="10px"
              backgroundColor="rgba(0,0,0,0.75)"
              p={1}
              style={{ borderRadius: '6px', zIndex: 30 }}
            >
              Scale: {Math.round(scale * 100)}%
            </Box>
          </Stack.Item>

          <Stack.Item width="380px" style={{ overflowY: 'auto' }}>
            <StatusPanel
              station_blocked={is_blocked}
              read_only={read_only}
              is_moving={is_moving}
              train_engine_active={train_engine_active}
              current_station={current_station}
              planned_station={planned_station}
              progress={progress}
              time_remaining={time_remaining}
              speed_kmh={speed_kmh}
              onStart={() => act('start_moving')}
              onStop={() => act('stop_moving')}
            />

            {isAdmin && (
              <>
                <Divider />
                <AdminPanel
                  current_station={current_station}
                  all_stations={all_stations}
                  onForceStart={() => act('start_moving')}
                  onForceStop={() => act('stop_moving')}
                  onUnload={() => act('unload_station')}
                  onLoad={(type) => act('load_station', { station_type: type })}
                  onCreateCargo={createCargoStation}
                  onVV={() => act('open_vv')}
                />
              </>
            )}

            {selectedObject && (
              <SelectedStationPanel
                selectedObject={selectedObject}
                possibleSet={possibleSet}
                is_moving={is_moving}
                read_only={read_only}
                canEdit={
                  isAdmin &&
                  !!selectedObject.station_ref &&
                  editable_stations.some(
                    (s) => s.ref === selectedObject.station_ref,
                  )
                }
                onClose={() => setSelectedId(null)}
                onSetAsNext={setAsNext}
                onEdit={editSelectedStation}
              />
            )}

            {!is_moving && possible_next.length > 0 && (
              <PossibleNextList
                possible_next={possible_next}
                onChoose={(type) => {
                  act('choose_next', { station_type: type });
                  const obj = map_data.objects.find((o) =>
                    o.id.startsWith(type),
                  );
                  setSelectedId(obj ? obj.id : null);
                }}
              />
            )}
          </Stack.Item>
        </Stack>

        {isAdmin && editingStation && (
          <StationEditorModal
            key={editingStation.ref}
            station={editingStation}
            allStations={editable_stations}
            nearOptions={nearstation_options}
            onSave={saveStation}
            onDelete={deleteStation}
            onClose={() => setEditingRef(null)}
          />
        )}
      </Window.Content>
    </Window>
  );
};
