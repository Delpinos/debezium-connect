CREATE SCHEMA IF NOT EXISTS test;

DROP TABLE IF EXISTS test.test_cdc CASCADE;
DROP TABLE IF EXISTS test.test_jdbc CASCADE;

CREATE OR REPLACE FUNCTION test.trigger_set_modified()
RETURNS TRIGGER AS $$
BEGIN
  NEW.modified = clock_timestamp();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE test.test_cdc (
  id serial NOT NULL PRIMARY KEY,
  name varchar(100),
  email varchar(200),
  department varchar(200),
  modified timestamp default clock_timestamp() NOT NULL
);

CREATE TABLE test.test_cdc_replica (
  id serial NOT NULL PRIMARY KEY,
  name varchar(100),
  email varchar(200),
  department varchar(200),
  modified timestamp default clock_timestamp() NOT NULL
);

CREATE TABLE test.test_jdbc (
  id serial NOT NULL PRIMARY KEY,
  name varchar(100),
  email varchar(200),
  department varchar(200),
  modified timestamp default clock_timestamp() NOT NULL
);

CREATE TABLE test.test_jdbc_replica (
  id serial NOT NULL PRIMARY KEY,
  name varchar(100),
  email varchar(200),
  department varchar(200),
  modified timestamp default clock_timestamp() NOT NULL
);

CREATE INDEX IF NOT EXISTS test_cdc_modified_idx on test.test_cdc(modified);
CREATE INDEX IF NOT EXISTS test_jdbc_modified_idx on test.test_jdbc(modified);
CREATE INDEX IF NOT EXISTS test_cdc_replica_modified_idx on test.test_cdc_replica(modified);
CREATE INDEX IF NOT EXISTS test_jdbc_replica_modified_idx on test.test_jdbc_replica(modified);

CREATE TRIGGER set_modified
BEFORE INSERT OR UPDATE ON test.test_cdc
FOR EACH ROW
EXECUTE PROCEDURE test.trigger_set_modified();

CREATE TRIGGER set_modified
BEFORE INSERT OR UPDATE ON test.test_jdbc
FOR EACH ROW
EXECUTE PROCEDURE test.trigger_set_modified();

INSERT INTO test.test_cdc (name, email, department) VALUES ('test1', 'test1@test1.com', 'engineering');
INSERT INTO test.test_cdc (name, email, department) VALUES ('test2', 'test2@test2.com', 'sales');
INSERT INTO test.test_cdc (name, email, department) VALUES ('test3', 'test3@test3.com', 'sales');
INSERT INTO test.test_cdc (name, email, department) VALUES ('test4', 'test4@test4.com', 'engineering');
INSERT INTO test.test_cdc (name, email, department) VALUES ('test5', 'test5@test5.com', 'engineering');
INSERT INTO test.test_cdc (name, email, department) VALUES ('test6', 'test6@test6.com', 'engineering');
INSERT INTO test.test_cdc (name, email, department) VALUES ('test7', 'test7@test7.com', 'engineering');
INSERT INTO test.test_cdc (name, email, department) VALUES ('test8', 'test8@test8.com', 'sales');
INSERT INTO test.test_cdc (name, email, department) VALUES ('test9', 'test9@test9.com', 'sales');
INSERT INTO test.test_cdc (name, email, department) VALUES ('test10', 'test10@test10.com', 'sales');

INSERT INTO test.test_jdbc (name, email, department) VALUES ('test1', 'test1@test1.com', 'engineering');
INSERT INTO test.test_jdbc (name, email, department) VALUES ('test2', 'test2@test2.com', 'sales');
INSERT INTO test.test_jdbc (name, email, department) VALUES ('test3', 'test3@test3.com', 'sales');
INSERT INTO test.test_jdbc (name, email, department) VALUES ('test4', 'test4@test4.com', 'engineering');
INSERT INTO test.test_jdbc (name, email, department) VALUES ('test5', 'test5@test5.com', 'engineering');
INSERT INTO test.test_jdbc (name, email, department) VALUES ('test6', 'test6@test6.com', 'engineering');
INSERT INTO test.test_jdbc (name, email, department) VALUES ('test7', 'test7@test7.com', 'engineering');
INSERT INTO test.test_jdbc (name, email, department) VALUES ('test8', 'test8@test8.com', 'sales');
INSERT INTO test.test_jdbc (name, email, department) VALUES ('test9', 'test9@test9.com', 'sales');
INSERT INTO test.test_jdbc (name, email, department) VALUES ('test10', 'test10@test10.com', 'sales');