import { type ReactNode, useRef, useState } from 'react';
import { Button, Floating, Icon } from 'tgui-core/components';
import { KEY } from 'tgui-core/keys';
import { classes } from 'tgui-core/react';
import { unit } from 'tgui-core/ui';

type DropdownEntry = {
  displayText: ReactNode;
  value: string | number;
};

type DropdownOption = string | DropdownEntry;

type Props = {
  onSelected: (value: any) => void;
  options: DropdownOption[];
  selected: DropdownOption | null | undefined;
} & Partial<{
  autoScroll: boolean;
  buttons: boolean;
  className: string;
  color: string;
  disabled: boolean;
  displayText: ReactNode;
  icon: string;
  iconOnly: boolean;
  iconRotation: number;
  iconSpin: boolean;
  menuWidth: string | number;
  noChevron: boolean;
  fluid: boolean;
  placeholder: string;
  clipSelectedText: boolean;
  onClick: (event: any) => void;
  width: string | number;
}>;

enum Direction {
  Next = 'next',
  Previous = 'previous',
}

const NONE = -1;

function getOptionValue(option: DropdownOption) {
  return typeof option === 'string' ? option : option.value;
}

export function BottomDropdown(props: Props) {
  const {
    autoScroll = true,
    buttons,
    className,
    color = 'default',
    disabled,
    displayText,
    icon,
    iconRotation,
    iconSpin,
    iconOnly,
    menuWidth,
    noChevron,
    onClick,
    onSelected,
    options = [],
    placeholder = 'Select...',
    selected,
    fluid,
    width = 15,
  } = props;

  const [open, setOpen] = useState(false);
  const innerRef = useRef<HTMLDivElement>(null);
  const selectedIndex =
    options.findIndex((option) => getOptionValue(option) === selected) || 0;

  function scrollToElement(position: number) {
    let scrollPos = position;
    if (position < selectedIndex) {
      scrollPos = position < 2 ? 0 : position - 2;
    } else {
      scrollPos =
        position > options.length - 3 ? options.length - 1 : position - 2;
    }

    const dropdownMenu = innerRef.current;
    const element = dropdownMenu?.children[scrollPos] as HTMLElement;
    if (dropdownMenu && element) {
      dropdownMenu.scrollTop = element.offsetTop;
    }
  }

  function updateSelected(direction: Direction) {
    if (options.length < 1 || disabled) {
      return;
    }

    const lastIndex = options.length - 1;
    let newIndex: number;
    if (selectedIndex < 0) {
      newIndex = direction === Direction.Next ? lastIndex : 0;
    } else if (direction === Direction.Next) {
      newIndex = selectedIndex === lastIndex ? 0 : selectedIndex + 1;
    } else {
      newIndex = selectedIndex === 0 ? lastIndex : selectedIndex - 1;
    }

    if (open && autoScroll) {
      scrollToElement(newIndex);
    }
    onSelected?.(getOptionValue(options[newIndex]));
  }

  return (
    <div className={classes(['Dropdown', fluid && 'Dropdown--fluid'])}>
      <Floating
        allowedOutsideClasses=".Dropdown__button"
        closeAfterInteract
        contentAutoWidth={!menuWidth}
        contentClasses="Dropdown__menu--wrapper"
        contentStyles={{ width: menuWidth ? unit(menuWidth) : undefined }}
        disabled={disabled}
        onMounted={() => {
          if (open && autoScroll && selectedIndex !== NONE) {
            scrollToElement(selectedIndex);
          }
        }}
        onOpenChange={setOpen}
        placement="bottom-start"
        content={
          <div ref={innerRef} className="Dropdown__menu">
            {options.length === 0 ? (
              <div className="Dropdown__menu--entry">No options</div>
            ) : (
              options.map((option) => {
                const value = getOptionValue(option);
                return (
                  <div
                    className={classes([
                      'Dropdown__menu--entry',
                      selected === value && 'selected',
                    ])}
                    key={value}
                    onClick={() => {
                      onSelected?.(value);
                    }}
                    onKeyDown={(event) => {
                      if (event.key === KEY.Enter) {
                        onSelected?.(value);
                      }
                    }}
                  >
                    {typeof option === 'string' ? option : option.displayText}
                  </div>
                );
              })
            )}
          </div>
        }
      >
        <div
          className={classes([
            'Dropdown__control',
            `Button--color--${color}`,
            disabled && 'Button--disabled',
            iconOnly && 'Dropdown__control--icon-only',
            className,
          ])}
          style={{ width: unit(width) }}
          onClick={(event) => {
            if (!disabled || open) {
              onClick?.(event);
            }
          }}
          onKeyDown={(event) => {
            if (event.key === KEY.Enter && !disabled) {
              onClick?.(event);
            }
          }}
        >
          {icon && (
            <Icon
              className="Dropdown__icon"
              name={icon}
              rotation={iconRotation}
              spin={iconSpin}
            />
          )}

          {!iconOnly && (
            <>
              <span className="Dropdown__selected-text">
                {displayText ||
                  (selected && getOptionValue(selected)) ||
                  placeholder}
              </span>

              {!noChevron && (
                <Icon
                  className={classes([
                    'Dropdown__icon',
                    'Dropdown__icon--arrow',
                    open && 'open',
                  ])}
                  name="chevron-down"
                />
              )}
            </>
          )}
        </div>
      </Floating>

      {buttons && (
        <>
          <Button
            className="Dropdown__button"
            disabled={disabled}
            icon="chevron-left"
            onClick={() => {
              updateSelected(Direction.Previous);
            }}
          />
          <Button
            className="Dropdown__button"
            disabled={disabled}
            icon="chevron-right"
            onClick={() => {
              updateSelected(Direction.Next);
            }}
          />
        </>
      )}
    </div>
  );
}
