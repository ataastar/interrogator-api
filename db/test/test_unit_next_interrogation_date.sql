CREATE OR REPLACE PROCEDURE test_unit_next_interrogation_date()
  LANGUAGE plpgsql
AS
$$
DECLARE
  v_from_language_id BIGINT;
  v_to_language_id BIGINT;
  v_root_unit_id BIGINT;
  v_unit1_id BIGINT;
  v_user_id BIGINT;

  v_name VARCHAR;
  v_code VARCHAR;

  v_content1 VARCHAR;
  v_unit_content_id BIGINT;
  v_translation_link_id BIGINT;

  v_next_interrogation_time TIMESTAMP;
  v_previous_interrogation_time TIMESTAMP;

  v_answer_id BIGINT;
  v_answer_time TIMESTAMP;
BEGIN
  v_from_language_id = create_language('test_from', 'TF');
  SELECT name, code INTO v_name, v_code FROM language;
  call test_assert_varchar('test_from', v_name);
  call test_assert_varchar('TF', v_code);
  call test_assert_is_not_null_bigint(v_from_language_id);

  v_to_language_id = create_language('test_to', 'TT');
  SELECT name, code INTO v_name, v_code FROM language WHERE language_id = v_to_language_id;
  call test_assert_varchar('test_to', v_name);
  call test_assert_varchar('TT', v_code);

  v_root_unit_id = create_unit_tree(NULL, 'ROOT', v_from_language_id, v_to_language_id);
  v_unit1_id = create_unit_tree(v_root_unit_id, 'Unit 1', v_from_language_id, v_to_language_id);

  v_user_id = add_user('ata.astar@gmail.com', 'ata');

  v_content1 = '{"id":"' || v_unit1_id || '","from":["asztal"],"to":["table1"],"example":"a","translated_example":"2"}';
  v_unit_content_id = insert_unit_content(v_content1::json);
  --RAISE NOTICE 'v_unit_content_id: %', v_unit_content_id;
  SELECT translation_link_id INTO v_translation_link_id FROM unit_content WHERE unit_content_id = v_unit_content_id;
  --RAISE NOTICE 'v_translation_link_id: %', v_translation_link_id;

  -- WRONG answer
  v_answer_id = add_answer(v_unit_content_id, v_user_id, false, 'X');
  SELECT next_interrogation_date INTO v_next_interrogation_time FROM translation_link WHERE translation_link_id = v_translation_link_id;
  call test_assert(v_next_interrogation_time IS NOT NULL, 'Next interrogation time should not be null!');
  call test_assert(v_next_interrogation_time <= CURRENT_TIMESTAMP,
    'Next interrogation time can not be in the future for wrong answer!');

  -- 1 RIGHT answer
  v_answer_id = add_answer(v_unit_content_id, v_user_id, true, 'X');
  SELECT next_interrogation_date INTO v_next_interrogation_time FROM translation_link WHERE translation_link_id = v_translation_link_id;
  call test_assert(v_next_interrogation_time IS NOT NULL, 'Next interrogation time should not be null!');
  --RAISE NOTICE 'v_next_interrogation_time: % ', v_next_interrogation_time;
  --RAISE NOTICE 'CURRENT_TIMESTAMP: % ', CURRENT_TIMESTAMP;
  call test_assert(v_next_interrogation_time BETWEEN add_time(CURRENT_TIMESTAMP, CAST(58 AS BIGINT)) AND add_time(CURRENT_TIMESTAMP, CAST(62 AS BIGINT)),
    'Next interrogation time should be in the future for 1 right answer!');

  -- WRONG answer
  v_answer_id = add_answer(v_unit_content_id, v_user_id, false, 'X');
  SELECT next_interrogation_date INTO v_next_interrogation_time FROM translation_link WHERE translation_link_id = v_translation_link_id;
  call test_assert(v_next_interrogation_time IS NOT NULL, 'Next interrogation time should not be null!');
  call test_assert(v_next_interrogation_time <= CURRENT_TIMESTAMP,
    'Next interrogation time can not be in the future for wrong answer!');

  -- 1 RIGHT answer
  v_answer_id = add_answer(v_unit_content_id, v_user_id, true, 'X');
  SELECT next_interrogation_date INTO v_next_interrogation_time FROM translation_link WHERE translation_link_id = v_translation_link_id;
  call test_assert(v_next_interrogation_time IS NOT NULL, 'Next interrogation time should not be null!');
  call test_assert(v_next_interrogation_time BETWEEN add_time(CURRENT_TIMESTAMP, CAST(58 AS BIGINT)) AND add_time(CURRENT_TIMESTAMP, CAST(62 AS BIGINT)),
    'Next interrogation time should be in the future for 1 right answer!');

  -- 2 RIGHT answer
  v_answer_id = add_answer(v_unit_content_id, v_user_id, true, 'X');
  SELECT next_interrogation_date INTO v_next_interrogation_time FROM translation_link WHERE translation_link_id = v_translation_link_id;
  call test_assert(v_next_interrogation_time IS NOT NULL, 'Next interrogation time should not be null!');
  call test_assert(v_next_interrogation_time BETWEEN add_time(CURRENT_TIMESTAMP, CAST(118 AS BIGINT)) AND add_time(CURRENT_TIMESTAMP, CAST(122 AS BIGINT)),
    'Next interrogation time should be in the future for 1 right answer!');


  -- remove all answers
  DELETE FROM answer WHERE translation_link_id = v_translation_link_id;
  -- set the next interrogation date to now (not to the future)
  UPDATE translation_link SET next_interrogation_date = NULL WHERE translation_link.translation_link_id = v_translation_link_id;
  -- add right answer before an hour
  v_answer_time = CURRENT_TIMESTAMP - make_interval(mins => 1);
  v_answer_id = add_answer(v_unit_content_id, v_user_id, true, 'X', v_answer_time);
  SELECT next_interrogation_date INTO v_next_interrogation_time FROM translation_link WHERE translation_link_id = v_translation_link_id;
  --RAISE NOTICE 'v_next_interrogation_time: % ', v_next_interrogation_time;
  call test_assert(v_next_interrogation_time IS NOT NULL, 'Next interrogation time should not be null!');
  call test_assert(v_next_interrogation_time BETWEEN add_time(v_answer_time, CAST(60-2 AS BIGINT)) AND add_time(v_answer_time, CAST(60+2 AS BIGINT)),
    'Next interrogation time should be 1 hour if the first RIGHT answer was 1 minute before!');

  -- add RIGHT now (first is a minutes ago)
  v_answer_time = CURRENT_TIMESTAMP;
  v_answer_id = add_answer(v_unit_content_id, v_user_id, true, 'X', v_answer_time);
  SELECT next_interrogation_date INTO v_next_interrogation_time FROM translation_link WHERE translation_link_id = v_translation_link_id;
  call test_assert(v_next_interrogation_time IS NOT NULL, 'Next interrogation time should not be null!');
  call test_assert(v_next_interrogation_time BETWEEN add_time(v_answer_time, CAST((60*60)-2 AS BIGINT)) AND add_time(v_answer_time, CAST((60*60)+2 AS BIGINT)),
    'Next interrogation time should be 2 hour later, if the first RIGHT answer was 1 minute before and we have now right answer!');

  -- add RIGHT now (first is a minutes ago)
  v_answer_time = CURRENT_TIMESTAMP;
  v_answer_id = add_answer(v_unit_content_id, v_user_id, true, 'X', v_answer_time);
  SELECT next_interrogation_date INTO v_next_interrogation_time FROM translation_link WHERE translation_link_id = v_translation_link_id;
  call test_assert(v_next_interrogation_time IS NOT NULL, 'Next interrogation time should not be null!');
  call test_assert(v_next_interrogation_time BETWEEN add_time(v_answer_time, CAST((60*60*2)-2 AS BIGINT)) AND add_time(v_answer_time, CAST((60*60*2)+2 AS BIGINT)),
    'Next interrogation time should be 2 hours after now! (first is 1 minute ago and we have 2 right now)!');

  --**** right -5 day ago | RIGHT now -> next should be 5 * day_in_seconds() * 5 seconds later + than actual | another RIGHT now -> next should be 5 * day_in_seconds() * 5 seconds later + than previous interrogation
  -- remove all answers
  DELETE FROM answer WHERE translation_link_id = v_translation_link_id;
  -- set the next interrogation date to null (not to the future)
  UPDATE translation_link SET next_interrogation_date = NULL WHERE translation_link.translation_link_id = v_translation_link_id;
  -- add right answer before 5 days
  v_answer_time = CURRENT_TIMESTAMP - make_interval(days => 5);
  v_answer_id = add_answer(v_unit_content_id, v_user_id, true, 'X', v_answer_time);
  SELECT next_interrogation_date INTO v_next_interrogation_time FROM translation_link WHERE translation_link_id = v_translation_link_id;
  call test_assert(v_next_interrogation_time IS NOT NULL, 'Next interrogation time should not be null!');
  call test_assert(v_next_interrogation_time BETWEEN add_time(v_answer_time, CAST(60-2 AS BIGINT)) AND add_time(v_answer_time, CAST(60+2 AS BIGINT)),
    'Next interrogation time should be 1 hour if the first RIGHT answer was 1 minute before!');

  -- add RIGHT now
  v_answer_time = CURRENT_TIMESTAMP;
  v_answer_id = add_answer(v_unit_content_id, v_user_id, true, 'X', v_answer_time);
  SELECT next_interrogation_date INTO v_next_interrogation_time FROM translation_link WHERE translation_link_id = v_translation_link_id;
  call test_assert(v_next_interrogation_time IS NOT NULL, 'Next interrogation time should not be null!');
  call test_assert(v_next_interrogation_time BETWEEN add_time(v_answer_time, CAST((5 * day_in_seconds() * 5) -1 AS BIGINT)) AND add_time(v_answer_time, CAST((5 * day_in_seconds() * 5) + 1 AS BIGINT)),
    'Next interrogation time should be 5 days later then the first answer, if the first RIGHT answer was 1 minute before and we have now right answer!');

  -- add RIGHT now (the interval should be added to the previously calculate next interrogation time)
  v_answer_time = CURRENT_TIMESTAMP;
  v_previous_interrogation_time = v_next_interrogation_time;
  v_answer_id = add_answer(v_unit_content_id, v_user_id, true, 'X', v_answer_time);
  SELECT next_interrogation_date INTO v_next_interrogation_time FROM translation_link WHERE translation_link_id = v_translation_link_id;
  /*RAISE NOTICE 'v_next_interrogation_time: %', v_next_interrogation_time;
  RAISE NOTICE 'v_answer_time: %', v_answer_time;
  RAISE NOTICE 'v_previous_interrogation_time: %', v_previous_interrogation_time;
  RAISE NOTICE 'min time: %', add_time(v_previous_interrogation_time, CAST((5 * day_in_seconds() * 5) - 1 AS BIGINT));
  RAISE NOTICE 'max time: %', add_time(v_previous_interrogation_time, CAST((5 * day_in_seconds() * 5) + 1 AS BIGINT));*/
  call test_assert(v_next_interrogation_time IS NOT NULL, 'Next interrogation time should not be null!');
  call test_assert(v_next_interrogation_time BETWEEN add_time(v_previous_interrogation_time, CAST((5 * day_in_seconds() * 5) -1 AS BIGINT)) AND add_time(v_previous_interrogation_time, CAST((5 * day_in_seconds() * 5) + 1 AS BIGINT)),
    'Next interrogation time should be 5 days later then the previous interrogation time!');


  --**** right -15 hour ago | RIGHT now -> next should be 737 217 seconds later + than actual, but the limit is 1 week (604 800 seconds)
  -- remove all answers
  DELETE FROM answer WHERE translation_link_id = v_translation_link_id;
  -- set the next interrogation date to null (not to the future)
  UPDATE translation_link SET next_interrogation_date = NULL WHERE translation_link.translation_link_id = v_translation_link_id;
  -- add right answer before 5 days
  v_answer_time = CURRENT_TIMESTAMP - make_interval(hours => 15);
  v_answer_id = add_answer(v_unit_content_id, v_user_id, true, 'X', v_answer_time);
  SELECT next_interrogation_date INTO v_next_interrogation_time FROM translation_link WHERE translation_link_id = v_translation_link_id;
  call test_assert(v_next_interrogation_time IS NOT NULL, 'Next interrogation time should not be null!');
  call test_assert(v_next_interrogation_time BETWEEN add_time(v_answer_time, CAST(60-2 AS BIGINT)) AND add_time(v_answer_time, CAST(60+2 AS BIGINT)),
    'Next interrogation time should be 1 hour if the first RIGHT answer was 1 minute before!');

  -- add RIGHT now
  v_answer_time = CURRENT_TIMESTAMP;
  v_answer_id = add_answer(v_unit_content_id, v_user_id, true, 'X', v_answer_time);
  SELECT next_interrogation_date INTO v_next_interrogation_time FROM translation_link WHERE translation_link_id = v_translation_link_id;
  call test_assert(v_next_interrogation_time IS NOT NULL, 'Next interrogation time should not be null!');
  call test_assert(v_next_interrogation_time BETWEEN add_time(v_answer_time, CAST(week_in_seconds() -1 AS BIGINT)) AND add_time(v_answer_time, CAST(week_in_seconds() + 1 AS BIGINT)),
    'Next interrogation time should be 1 week later then the first answer, if the first RIGHT answer was 15 days before and we have now right answer!');

  RAISE NOTICE 'test_unit_next_interrogation_date was SUCCESS!';

  ROLLBACK;
END;
$$
