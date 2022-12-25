CREATE OR REPLACE FUNCTION add_time(p_time TIMESTAMP WITH TIME ZONE, p_to_be_added BIGINT) RETURNS TIMESTAMP
  LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN p_time + make_interval(secs => p_to_be_added);
END
$$;
