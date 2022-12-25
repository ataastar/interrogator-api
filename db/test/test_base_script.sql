CREATE OR REPLACE PROCEDURE test_base_script()
  LANGUAGE plpgsql
AS
$$
BEGIN
  INSERT INTO interrogation_interval(elapsed_time, multiplier) VALUES (60, 60);
  INSERT INTO interrogation_interval(elapsed_time, multiplier) VALUES (3600, 24);
  INSERT INTO interrogation_interval(elapsed_time, multiplier) VALUES (86400, 7);
  INSERT INTO interrogation_interval(elapsed_time, multiplier) VALUES (345600, 4);
  INSERT INTO interrogation_interval(elapsed_time, multiplier) VALUES (2764800, 8);
END;
$$
