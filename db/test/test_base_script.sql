CREATE OR REPLACE PROCEDURE test_base_script()
  LANGUAGE plpgsql
AS
$$
BEGIN
  INSERT INTO interrogation_interval(elapsed_time, multiplier, description) VALUES (60, 60, '1 minute');
  INSERT INTO interrogation_interval(elapsed_time, multiplier, description) VALUES (3600, 24, '1 hour');
  INSERT INTO interrogation_interval(elapsed_time, multiplier, description) VALUES (86400, 7, '1 day');
  INSERT INTO interrogation_interval(elapsed_time, multiplier, description) VALUES (604800, 4, '1 week');
  INSERT INTO interrogation_interval(elapsed_time, multiplier, description) VALUES (4838400, 8, '1 month');
END;
$$
