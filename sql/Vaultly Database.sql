
-- Database creation

CREATE DATABASE vaultly;

-- Tables creation

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    sign_up_date DATE NOT NULL,
    country NVARCHAR(100),
    age_group NVARCHAR(50),
    gender NVARCHAR(50),
    plan_type NVARCHAR(50)
);

CREATE TABLE subscriptions (
    subscription_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    plan_type NVARCHAR(50),
    plan_value DECIMAL(10,2),
    start_date DATE,
    end_date DATE,
    status NVARCHAR(50),
    churn_date DATE,
    CONSTRAINT FK_subscriptions_users FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE invoices (
    invoice_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    subscription_id INT NOT NULL,
    invoice_date DATE,
    amount DECIMAL(10,2),
    payment_status NVARCHAR(50),
    invoice_number INT,
    CONSTRAINT FK_invoices_users FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT FK_invoices_subscriptions FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id)
);

CREATE TABLE onboarding_events (
    event_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    step_name NVARCHAR(255),
    step_number INT,
    completed BIT, -- SQL Server uses BIT for 1/0 true/false flags
    event_timestamp DATETIME2,
    CONSTRAINT FK_onboarding_events_users FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE product_events (
    event_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    event_type NVARCHAR(255),
    event_timestamp DATETIME2,
    days_since_signup INT,
    CONSTRAINT FK_product_events_users FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE acquisition (
    acquisition_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    channel NVARCHAR(100),
    campaign_name NVARCHAR(255),
    utm_source NVARCHAR(100),
    utm_medium NVARCHAR(100),
    acquisition_date DATE,
    acquisition_cost DECIMAL(10,2),
    CONSTRAINT FK_acquisition_users FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Bulk inserts

BULK INSERT users
FROM 'C:\Vaulty\users.csv'
WITH (
    FIRSTROW = 2,           -- Skips the header row
    FIELDTERMINATOR = ',',  -- Separates columns by comma
    ROWTERMINATOR = '0x0a',   -- New line character (use '\r\n' if generated on Windows)
    TABLOCK
);

BULK INSERT subscriptions
FROM 'C:\Vaulty\subscriptions.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

BULK INSERT invoices
FROM 'C:\Vaulty\invoices.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

BULK INSERT onboarding_events
FROM 'C:\Vaulty\onboarding_events.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

BULK INSERT product_events
FROM 'C:\Vaulty\product_events.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

BULK INSERT acquisition
FROM 'C:\Vaulty\acquisition.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);




















