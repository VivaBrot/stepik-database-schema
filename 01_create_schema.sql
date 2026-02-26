DROP SCHEMA IF EXISTS stepik;
CREATE SCHEMA stepik;
USE stepik;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(50) NOT NULL,
    details VARCHAR(50),
    join_date DATE NOT NULL,
    avatar TEXT,
    is_active BOOLEAN NOT NULL,
    knowledge INT NOT NULL DEFAULT 0,
    reputation INT NOT NULL DEFAULT 0,
    followers_count INT NOT NULL DEFAULT 0,
    days_without_break INT NOT NULL DEFAULT 0,
    days_without_break_max INT NOT NULL DEFAULT 0,
    solved_tasks INT NOT NULL DEFAULT 0
);

DROP TABLE IF EXISTS courses;
CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50) NOT NULL,
    created_date DATE NOT NULL,
    summary TEXT,
    photo TEXT,
    price DECIMAL NOT NULL
);

DROP TABLE IF EXISTS user_courses;
CREATE TABLE user_courses (
    user_id INT,
    course_id INT,
    is_favorite BOOLEAN NOT NULL,
    is_pinned BOOLEAN NOT NULL,
    is_archived BOOLEAN NOT NULL,
    last_viewed DATE NOT NULL,
    PRIMARY KEY (user_id , course_id),
    FOREIGN KEY (user_id)
        REFERENCES users (id),
    FOREIGN KEY (course_id)
        REFERENCES courses (id)
);

DROP TABLE IF EXISTS courses_authors;
CREATE TABLE courses_authors (
    course_id INT,
    user_id INT,
    PRIMARY KEY (course_id , user_id),
    FOREIGN KEY (course_id)
        REFERENCES courses (id),
    FOREIGN KEY (user_id)
        REFERENCES users (id)
);

DROP TABLE IF EXISTS certificates;
CREATE TABLE certificates (
    user_id INT,
    course_id INT,
    grade INT NOT NULL,
    issue_date DATE NOT NULL,
    url TEXT NOT NULL,
    PRIMARY KEY (user_id , course_id),
    FOREIGN KEY (user_id)
        REFERENCES users (id),
    FOREIGN KEY (course_id)
        REFERENCES courses (id)
);

DROP TABLE IF EXISTS social_providers;
CREATE TABLE social_providers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name TEXT NOT NULL,
    logo_url TEXT NOT NULL
);

DROP TABLE IF EXISTS user_social_providers;
CREATE TABLE user_social_providers (
    user_id INT,
    social_provider_id INT,
    connect_url TEXT NOT NULL,
    PRIMARY KEY (user_id , social_provider_id),
    FOREIGN KEY (user_id)
        REFERENCES users (id),
    FOREIGN KEY (social_provider_id)
        REFERENCES social_providers (id)
);

DROP TABLE IF EXISTS certificate_settings;
CREATE TABLE certificate_settings (
    course_id INT,
    logo_url TEXT,
    signature_url TEXT,
    is_certificate_auto_issued BOOLEAN NOT NULL,
    regular_threshold INT NOT NULL,
    excellent_threshold INT NOT NULL,
    PRIMARY KEY (course_id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

DROP TABLE IF EXISTS units;
CREATE TABLE units (
    id INT PRIMARY KEY,
    course_id INT NOT NULL,
    title TEXT,
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

DROP TABLE IF EXISTS lessons;
CREATE TABLE lessons (
    id INT PRIMARY KEY,
    title TEXT,
    epic_count INT NOT NULL,
    abuse_count INT NOT NULL
);

DROP TABLE IF EXISTS unit_lessons;
CREATE TABLE unit_lessons (
    unit_id INT,
    lesson_id INT,
    PRIMARY KEY (unit_id , lesson_id),
    FOREIGN KEY (unit_id) REFERENCES units(id),
    FOREIGN KEY (lesson_id) REFERENCES lessons(id)
);

DROP TABLE IF EXISTS steps;
CREATE TABLE steps (
    id INT PRIMARY KEY,
    lesson_id INT NOT NULL,
    position INT NOT NULL,
    title TEXT,
    content TEXT,
    cost INT NOT NULL,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id)
);

DROP TABLE IF EXISTS progresses;
CREATE TABLE progresses (
    user_id INT,
    step_id INT,
    is_passed BOOLEAN NOT NULL,
    score INT NOT NULL,
    PRIMARY KEY (user_id, step_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (step_id) REFERENCES steps(id)
);

DROP TABLE IF EXISTS comments;
CREATE TABLE comments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    step_id INT,
    reply_comment_id INT,
    user_id INT NOT NULL,
    time DATE NOT NULL,
    text TEXT NOT NULL,
    epic_count INT NOT NULL,
    abuse_count INT NOT NULL,
    FOREIGN KEY (step_id)
        REFERENCES steps (id),
    FOREIGN KEY (reply_comment_id)
        REFERENCES comments (id),
    FOREIGN KEY (user_id)
        REFERENCES users (id)
);

DROP TABLE IF EXISTS course_reviews;
CREATE TABLE course_reviews (
    course_id INT,
    user_id INT,
    comment_id INT,
    created_date DATE NOT NULL,
    text TEXT,
    score INT NOT NULL,
    epic_count INT NOT NULL,
    abuse_count INT NOT NULL,
    PRIMARY KEY (course_id, user_id),
    FOREIGN KEY (course_id) REFERENCES courses(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (comment_id) REFERENCES comments(id)
);