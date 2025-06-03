import { useState } from 'react';
import {
  Box,
  Button,
  Dropdown,
  LabeledControls,
  Modal,
  NumberInput,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Loader } from './common/Loader';

type MaturityPromptData = {
  year: number;
  month: number;
  day: number;
  timeout: number;
  current_year: number;
  current_month: number;
  current_day: number;
  save_birthday: boolean;
  public_birthday: boolean;
};

export const MaturityPrompt = (props) => {
  const { act, data } = useBackend<MaturityPromptData>();
  const {
    current_year,
    current_month,
    current_day,
    timeout,
    save_birthday,
    public_birthday,
  } = data;
  const [set_year, setYear] = useState(current_year);
  const [set_month, setMonth] = useState(current_month);
  const [set_day, setDay] = useState(current_day);
  const [buttonClicked, setButtonClicked] = useState(false);
  const [showCalendar, setShowCalendar] = useState(false);

  const windowHeight = 420;
  const windowWidth = 420;

  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  const handleButtonClick = () => {
    if (buttonClicked) {
      // If button has already been clicked once, perform the submit action
      act('submit', {
        year: set_year,
        month: set_month,
        day: set_day,
        save_birthday: save_birthday,
        public_birthday: public_birthday,
      });
    } else {
      // If button hasn't been clicked yet, set it to clicked state
      setButtonClicked(true);
    }
  };

  const handleSaveBirthdayToggle = () => {
    act('toggle_save_birthday');
  };

  const handlePublicBirthdayToggle = () => {
    act('toggle_public_birthday');
  };

  // Get days in month for validation
  const daysInMonth = (year: number, month: number) => {
    const daysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (month === 2 && year % 4 === 0) {
      return 29; // leap year
    }
    return daysInMonths[month - 1] || 31;
  };

  const maxDay = daysInMonth(set_year, set_month);

  // Ensure day doesn't exceed month limits when month changes
  const handleMonthChange = (newMonth: number) => {
    setMonth(newMonth);
    const maxDayForMonth = daysInMonth(set_year, newMonth);
    if (set_day > maxDayForMonth) {
      setDay(maxDayForMonth);
    }
  };

  const handleYearChange = (newYear: number) => {
    setYear(newYear);
    const maxDayForMonth = daysInMonth(newYear, set_month);
    if (set_day > maxDayForMonth) {
      setDay(maxDayForMonth);
    }
  };

  const handleCalendarSubmit = (year: number, month: number, day: number) => {
    setYear(year);
    setMonth(month);
    setDay(day);
    setShowCalendar(false);
  };

  return (
    <Window height={windowHeight} title={'Are you 18+?'} width={windowWidth}>
      {!!timeout && <Loader value={timeout} />}
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Box color="label" m={1}>
              This is a community with a minimum age requirement. Please submit
              your date of birth. We only retain the year and month, the day is
              discarded after the initial check unless you opt in to birthday
              celebrations below.
            </Box>
          </Stack.Item>

          <Stack.Item>
            <Section title="Date of Birth">
              <Stack>
                <Stack.Item grow>
                  <LabeledControls>
                    <LabeledControls.Item label="Year">
                      <NumberInput
                        value={set_year}
                        minValue={1900}
                        maxValue={current_year}
                        step={1}
                        stepPixelSize={3}
                        onChange={handleYearChange}
                        width="80px"
                      />
                    </LabeledControls.Item>
                    <LabeledControls.Item label="Month">
                      <NumberInput
                        value={set_month}
                        minValue={1}
                        maxValue={12}
                        step={1}
                        stepPixelSize={5}
                        onChange={handleMonthChange}
                        width="60px"
                      />
                    </LabeledControls.Item>
                    <LabeledControls.Item label="Day">
                      <NumberInput
                        value={set_day}
                        minValue={1}
                        maxValue={maxDay}
                        step={1}
                        stepPixelSize={5}
                        onChange={(value) => setDay(value)}
                        width="60px"
                      />
                    </LabeledControls.Item>
                  </LabeledControls>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="calendar"
                    onClick={() => setShowCalendar(true)}
                    tooltip="Open Calendar"
                    color="blue"
                  />
                </Stack.Item>
              </Stack>
              <Box color="label" fontSize="0.85em" mt={1}>
                Selected: {months[set_month - 1]} {set_day}, {set_year}
              </Box>
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section title="Birthday Options">
              <Stack vertical>
                <Stack.Item>
                  <Button.Checkbox
                    checked={save_birthday}
                    onClick={handleSaveBirthdayToggle}
                    fluid
                  >
                    Save my birthday (day included, not just month and year)
                  </Button.Checkbox>
                  <Box color="label" fontSize="0.85em" mt={0.5} ml={1}>
                    Check this to save your full birthday date for features
                    below
                  </Box>
                </Stack.Item>
                <Stack.Item mt={1}>
                  <Button.Checkbox
                    checked={public_birthday}
                    disabled={!save_birthday}
                    onClick={handlePublicBirthdayToggle}
                    color={save_birthday ? 'default' : 'grey'}
                    fluid
                  >
                    Use my birthday for integration and contests
                  </Button.Checkbox>
                  <Box color="label" fontSize="0.85em" mt={0.5} ml={1}>
                    On your birthday, server and Discord will notify players.
                    (WIP) Age and birth year are NOT revealed.
                  </Box>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Button
              width="100%"
              color={buttonClicked ? 'red' : 'green'}
              content={buttonClicked ? 'Confirm' : 'Submit'}
              icon="calendar"
              onClick={handleButtonClick}
            />
          </Stack.Item>
        </Stack>
      </Window.Content>

      {showCalendar && (
        <CalendarModal
          currentYear={current_year}
          selectedYear={set_year}
          selectedMonth={set_month}
          selectedDay={set_day}
          months={months}
          daysInMonth={daysInMonth}
          onSubmit={handleCalendarSubmit}
          onClose={() => setShowCalendar(false)}
        />
      )}
    </Window>
  );
};

// Calendar Modal Component
const CalendarModal = (props) => {
  const {
    currentYear,
    selectedYear,
    selectedMonth,
    selectedDay,
    months,
    daysInMonth,
    onSubmit,
    onClose,
  } = props;

  const [year, setYear] = useState(selectedYear);
  const [month, setMonth] = useState(selectedMonth);
  const [day, setDay] = useState(selectedDay);

  const maxDay = daysInMonth(year, month);

  const handleMonthChange = (newMonth: number) => {
    setMonth(newMonth);
    const maxDayForMonth = daysInMonth(year, newMonth);
    if (day > maxDayForMonth) {
      setDay(maxDayForMonth);
    }
  };

  const handleYearChange = (newYear: number) => {
    setYear(newYear);
    const maxDayForMonth = daysInMonth(newYear, month);
    if (day > maxDayForMonth) {
      setDay(maxDayForMonth);
    }
  };

  return (
    <Modal
      height="250px"
      width="350px"
      style={{
        border: '1px solid #4a90e2',
      }}
    >
      <Section title="Calendar Picker" fill>
        <Stack vertical fill>
          <Stack.Item>
            <Stack>
              <Stack.Item>
                <Box color="label" mb={1}>
                  Month:
                </Box>
                <Dropdown
                  selected={months[month - 1]}
                  options={months.map((monthName, index) => ({
                    displayText: monthName,
                    value: index + 1,
                  }))}
                  onSelected={handleMonthChange}
                  width="100px"
                />
              </Stack.Item>
              <Stack.Item ml={1}>
                <Box color="label" mb={1}>
                  Year:
                </Box>
                <Dropdown
                  selected={year.toString()}
                  options={Array.from(
                    { length: currentYear - 1900 + 1 },
                    (_, i) => {
                      const yearValue = currentYear - i;
                      return {
                        displayText: yearValue.toString(),
                        value: yearValue,
                      };
                    },
                  )}
                  onSelected={handleYearChange}
                  width="70px"
                />
              </Stack.Item>
              <Stack.Item ml={1}>
                <Box color="label" mb={1}>
                  Day:
                </Box>
                <Dropdown
                  selected={day.toString()}
                  options={Array.from({ length: maxDay }, (_, i) => {
                    const dayValue = i + 1;
                    return {
                      displayText: dayValue.toString(),
                      value: dayValue,
                    };
                  })}
                  onSelected={setDay}
                  width="50px"
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>

          <Stack.Item mt={1}>
            <Box color="label" fontSize="0.9em" textAlign="center">
              Selected: {months[month - 1]} {day}, {year}
            </Box>
          </Stack.Item>

          <Stack.Item mt={1}>
            <Stack>
              <Stack.Item grow>
                <Button
                  width="100%"
                  color="green"
                  content="Apply"
                  icon="check"
                  onClick={() => onSubmit(year, month, day)}
                />
              </Stack.Item>
              <Stack.Item ml={1}>
                <Button
                  width="100%"
                  color="red"
                  content="Cancel"
                  icon="times"
                  onClick={onClose}
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Section>
    </Modal>
  );
};
