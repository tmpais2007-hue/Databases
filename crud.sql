-- Before insert
SELECT * FROM School;

-- Create data
INSERT INTO School (name, city, country)
VALUES ('New Academy', 'Lyon', 'France');

-- After insert
SELECT * FROM School;

-- Update
UPDATE School
SET city = 'Marseille'
WHERE name = 'New Academy';

-- After update
SELECT * FROM School;

-- Delete
DELETE FROM School
WHERE name = 'New Academy';

-- After delete
SELECT * FROM School;