PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users
(
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

 CREATE TABLE questions
 (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows
 (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL, 

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE replies
 (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    parent_reply_id INTEGER,
    body TEXT NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Frida', 'Pulido'),
  ('Tony', 'Ng'),
  ('Michael', 'Jackson');

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('Cats', 'Do you like cats?', 1),
  ('Dogs', 'Do all dogs go to heaven?', 2),
  ('Dance', 'How can I teach the moonwalk?', 3);

INSERT INTO
  question_follows (question_id, user_id)
VALUES
  (2, 1),
  (3, 2),
  (1, 3);

INSERT INTO
    replies(question_id, user_id, parent_reply_id, body)
VALUES
    (1, 2, NULL, 'I''m sorry, I prefer dogs.'),
    (1, 3, 1, 'Cats rule!');

INSERT INTO
    question_likes(question_id, user_id)
VALUES
    (1, 2),
    (1, 3),
    (2, 1);





