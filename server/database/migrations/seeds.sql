-- create the user parcels
CREATE TABLE
IF NOT EXISTS users
(
    id SERIAL PRIMARY KEY,
    full_name VARCHAR
(30) NOT NULL,
    phone VARCHAR
(15) NOT NULL,
    email VARCHAR
(50) NOT NULL,
    password VARCHAR
(200) NOT NULL,
    role VARCHAR
(10) NOT NULL,
    avatar VARCHAR
(80) DEFAULT NULL,
    createdat timestamp NOT NULL DEFAULT now
(),
    updatedat timestamp NOT NULL DEFAULT now
(),
    UNIQUE
(email,phone)
);

-- create the parcels table
CREATE TABLE
IF NOT EXISTS parcels
(
    id SERIAL PRIMARY KEY,
    recipient_phone VARCHAR
(15) NOT NULL,
    recipient_name VARCHAR
(50),
    destination VARCHAR
(50) NOT NULL,
    present_location VARCHAR
(30) NOT NULL,
    origin VARCHAR
(30) NOT NULL,
    weight numeric CHECK
(weight > 0),
    sender INTEGER NOT NULL REFERENCES users
(id),
    status VARCHAR
(20) NOT NULL,
    price numeric NOT NULL CHECK
(price > 0),
    createdat timestamp NOT NULL DEFAULT now
(),
    updatedat timestamp NOT NULL DEFAULT now
()
);

-- create the timestamp function
CREATE OR REPLACE FUNCTION update_timestamp
()
  RETURNS TRIGGER AS $$
BEGIN
  NEW.updatedat = now
();
RETURN NEW;
END;
  $$ language 'plpgsql';

--   drop the existing user_timestamp trigger
DROP TRIGGER IF EXISTS user_timestamp
ON users;

-- recreate it 
CREATE TRIGGER user_timestamp BEFORE
UPDATE
  ON parcels FOR EACH ROW
EXECUTE PROCEDURE update_timestamp
();

--   drop the existing parcels_timestamp trigger
DROP TRIGGER IF EXISTS parcels_timestamp
ON parcels;

-- recreate it 
CREATE TRIGGER parcels_timestamp BEFORE
UPDATE
  ON parcels FOR EACH ROW
EXECUTE PROCEDURE update_timestamp
();