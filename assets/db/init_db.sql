CREATE TABLE profiles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT NOT NULL,
    birthday DATE,
    gender INTEGER,
    weight DOUBLE,
    weight_unit TEXT,
    height DOUBLE,
    height_unit TEXT,
    is_deleted INTEGER DEFAULT 0  -- Soft delete column (0 = not deleted, 1 = deleted)
);

CREATE TABLE measurements (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    profile_id INTEGER,
    date DATETIME,
    systolis INTEGER,
    diastolis INTEGER,
    pulse INTEGER,
    weight DOUBLE,
    age INTEGER,
    feeling TEXT,
    measured_site TEXT,
    body_position TEXT,
    note TEXT,
    is_deleted INTEGER DEFAULT 0,  -- Soft delete column
    FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE  -- Foreign key constraint
);

CREATE TABLE reminders (
    id INTEGER PRIMARY KEY,
    time TIME,
    isActive INTEGER,
    is_deleted INTEGER DEFAULT 0  -- Soft delete column
);
