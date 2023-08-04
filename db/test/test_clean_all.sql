CREATE OR REPLACE PROCEDURE test_clean_all()
  LANGUAGE plpgsql
AS
$$
BEGIN
  TRUNCATE TABLE interrogation_interval;
  truncate table answer;
  truncate table log;
  truncate table translation;
  truncate table unit_content;
  truncate table unit_tree cascade;

  truncate table word_type_form_phrase cascade;
  truncate table word_type_from;
  truncate table word_type_unit_link;
  truncate table word_type_form cascade;
  truncate table word_type cascade;
  truncate table word_type_unit cascade;

  truncate table phrase cascade;
  truncate table language cascade;
  truncate table users;
  truncate table user_role;

  truncate table translation_link cascade;
END;
$$
