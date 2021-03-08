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

INSERT INTO test.test_cdc (name, email, department) VALUES ('test11', 'test11@test11.com', 'sales');
INSERT INTO test.test_cdc (name, email, department) VALUES ('test12', 'test12@test12.com', 'engineering');
INSERT INTO test.test_cdc (name, email, department) VALUES ('test13', 'test13@test13.com', 'sales');
INSERT INTO test.test_cdc (name, email, department) VALUES ('test14', 'test14@test14.com', 'engineering');
INSERT INTO test.test_cdc (name, email, department) VALUES ('test15', 'test15@test15.com', 'sales');
INSERT INTO test.test_cdc (name, email, department) VALUES ('test16', 'test16@test16.com', 'engineering');
INSERT INTO test.test_cdc (name, email, department) VALUES ('test17', 'test17@test17.com', 'sales');
INSERT INTO test.test_cdc (name, email, department) VALUES ('test18', 'test18@test18.com', 'sales');
INSERT INTO test.test_cdc (name, email, department) VALUES ('test19', 'test19@test19.com', 'engineering');
INSERT INTO test.test_cdc (name, email, department) VALUES ('test20', 'test10@test20.com', 'sales');

INSERT INTO test.test_jdbc (name, email, department) VALUES ('test11', 'test11@test11.com', 'sales');
INSERT INTO test.test_jdbc (name, email, department) VALUES ('test12', 'test12@test12.com', 'engineering');
INSERT INTO test.test_jdbc (name, email, department) VALUES ('test13', 'test13@test13.com', 'sales');
INSERT INTO test.test_jdbc (name, email, department) VALUES ('test14', 'test14@test14.com', 'engineering');
INSERT INTO test.test_jdbc (name, email, department) VALUES ('test15', 'test15@test15.com', 'sales');
INSERT INTO test.test_jdbc (name, email, department) VALUES ('test16', 'test16@test16.com', 'engineering');
INSERT INTO test.test_jdbc (name, email, department) VALUES ('test17', 'test17@test17.com', 'sales');
INSERT INTO test.test_jdbc (name, email, department) VALUES ('test18', 'test18@test18.com', 'sales');
INSERT INTO test.test_jdbc (name, email, department) VALUES ('test19', 'test19@test19.com', 'engineering');
INSERT INTO test.test_jdbc (name, email, department) VALUES ('test20', 'test10@test20.com', 'sales');