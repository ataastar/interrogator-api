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

  v_answer_time TIMESTAMP;
  --v_answer_id BIGINT;

  v_boolean_result BOOLEAN;
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
  v_boolean_result = add_answer(v_unit_content_id, v_user_id, false, 'X');
  SELECT next_interrogation_date INTO v_answer_time FROM translation_link WHERE translation_link_id = v_translation_link_id;
  --RAISE NOTICE 'v_answer_time: %', v_answer_time;
  call test_assert(v_answer_time <= CURRENT_TIMESTAMP, 'Answer time can not be in the future for wrong answer!');

  -- 1 RIGHT answer
  v_boolean_result = add_answer(v_unit_content_id, v_user_id, true, 'X');
  SELECT next_interrogation_date INTO v_answer_time FROM translation_link WHERE translation_link_id = v_translation_link_id;
  --RAISE NOTICE 'v_answer_time: %', v_answer_time;
  call test_assert(v_answer_time > CURRENT_TIMESTAMP, 'Answer time should be in the future for 1 right answer!');

  RAISE NOTICE 'test_unit_next_interrogation_date was SUCCESS!';

  ROLLBACK;
END;
$$
