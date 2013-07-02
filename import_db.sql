CREATE TABLE users (

  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL

  );

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255) NOT NULL,
  author_id INTEGER NOT NULL,
  FOREIGN KEY(author_id) REFERENCES users(id)
  );

CREATE TABLE question_followers (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  follower_id INTEGER NOT NULL,
  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(follower_id) REFERENCES users(id)
  );

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  reply VARCHAR(255) NOT NULL,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  author_id INTEGER NOT NULL,
  FOREIGN KEY(parent_id) REFERENCES replies(id),
  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(author_id) references users(id)
  );

CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(user_id) REFERENCES users(id)
  );

INSERT INTO users (fname,lname)
  VALUES ('a','kang'),('s','unni'),('s','omebody');

INSERT INTO questions (title, body, author_id)
  VALUES  ('qtitle','firstquestion',3),('qtitle2','secondquestion',3);

INSERT INTO question_followers (question_id, follower_id)
  VALUES (1,1), (1,2), (2,1), (2,2);

INSERT INTO replies (reply,question_id,parent_id,author_id)
  VALUES ('reply1',1,NULL,1), ('reply2',1,1,2), ('reply3',1,2,1);

INSERT INTO question_likes (question_id,user_id)
  VALUES (1,1), (1,2), (1,3), (2,3);

