CREATE OR REPLACE FUNCTION week_in_seconds() RETURNS BIGINT
  LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN 60 * 60 * 24 * 7;
END
$$ IMMUTABLE;
