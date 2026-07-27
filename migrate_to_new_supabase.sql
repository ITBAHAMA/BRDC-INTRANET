-- ============================================================
-- BRDC Employee Portal — Full Database Migration
-- Source project : mtrrslztrjcxwatdossu
-- Target project : ryzucipineonaytxotuu
-- Generated      : 2026-07-18
--
-- HOW TO RUN:
--   1. Go to https://supabase.com/dashboard/project/ryzucipineonaytxotuu
--   2. Click "SQL Editor" in the left sidebar
--   3. Paste this entire file and click "Run"
-- ============================================================


-- ========================
-- STEP 1 — SEQUENCES
-- ========================

CREATE SEQUENCE IF NOT EXISTS dept_announcements_id_seq;
CREATE SEQUENCE IF NOT EXISTS announcement_acknowledgements_id_seq;
CREATE SEQUENCE IF NOT EXISTS login_logs_id_seq;


-- ========================
-- STEP 2 — CREATE TABLES
-- ========================

CREATE TABLE IF NOT EXISTS profiles (
  id                uuid        DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
  username          text        NOT NULL,
  full_name         text,
  department        text,
  password          text,
  security_question text,
  security_answer   text,
  is_admin          boolean     DEFAULT false,
  created_at        timestamp   DEFAULT now(),
  position          text
);

CREATE TABLE IF NOT EXISTS birthdays (
  id         bigint       NOT NULL PRIMARY KEY,
  name       text         NOT NULL,
  dept       text,
  bday       text,
  start_date date,
  created_at timestamptz  DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS directory_entries (
  id         bigint      NOT NULL PRIMARY KEY,
  name       text        NOT NULL,
  position   text        NOT NULL,
  dept       text,
  email      text,
  phone      text,
  created_at timestamptz DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS announcements (
  id        bigint      NOT NULL PRIMARY KEY,
  title     text        NOT NULL,
  body      text        NOT NULL,
  type      text        DEFAULT 'info' NOT NULL,
  until     date,
  posted_by text,
  posted_at timestamptz DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS quick_links (
  id         bigint      NOT NULL PRIMARY KEY,
  label      text        NOT NULL,
  url        text        NOT NULL,
  dept       text        DEFAULT 'all' NOT NULL,
  icon       text        DEFAULT 'ph-fill ph-link' NOT NULL,
  created_at timestamptz DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS admin_memos (
  id          bigint      NOT NULL PRIMARY KEY,
  title       text        NOT NULL,
  dept        text        DEFAULT 'all' NOT NULL,
  description text,
  filename    text,
  data_url    text,
  uploaded_by text,
  uploaded_at timestamptz DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS dept_announcements (
  id        bigint      DEFAULT nextval('dept_announcements_id_seq') NOT NULL PRIMARY KEY,
  title     text        NOT NULL,
  body      text        NOT NULL,
  dept      text        DEFAULT 'all' NOT NULL,
  posted_by text        NOT NULL,
  posted_at timestamptz DEFAULT now() NOT NULL,
  pinned    boolean     DEFAULT false NOT NULL,
  priority  text        DEFAULT 'info' NOT NULL
);

CREATE TABLE IF NOT EXISTS support_requests (
  id               uuid        DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
  request_type     text        DEFAULT 'Other' NOT NULL,
  subject          text        NOT NULL,
  description      text        NOT NULL,
  urgency          text        DEFAULT 'Normal' NOT NULL,
  employee_name    text,
  employee_dept    text,
  employee_username text,
  status           text        DEFAULT 'Open' NOT NULL,
  admin_notes      text,
  created_at       timestamptz DEFAULT now(),
  updated_at       timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS broadcast_alert (
  id         integer     DEFAULT 1 NOT NULL PRIMARY KEY,
  message    text        DEFAULT '' NOT NULL,
  type       text        DEFAULT 'info' NOT NULL,
  is_active  boolean     DEFAULT false NOT NULL,
  updated_at timestamptz DEFAULT now(),
  updated_by text        DEFAULT ''
);

CREATE TABLE IF NOT EXISTS it_systems (
  id         uuid        DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
  name       text        NOT NULL,
  category   text        DEFAULT 'General' NOT NULL,
  status     text        DEFAULT 'online' NOT NULL,
  note       text        DEFAULT '',
  sort_order integer     DEFAULT 0,
  updated_at timestamptz DEFAULT now(),
  updated_by text        DEFAULT ''
);

CREATE TABLE IF NOT EXISTS announcement_acknowledgements (
  id              bigint      DEFAULT nextval('announcement_acknowledgements_id_seq') NOT NULL PRIMARY KEY,
  announcement_id bigint      NOT NULL,
  username        text        NOT NULL,
  full_name       text,
  dept            text,
  position        text,
  acknowledged_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS login_logs (
  id          bigint      DEFAULT nextval('login_logs_id_seq') NOT NULL PRIMARY KEY,
  username    text        NOT NULL,
  full_name   text,
  dept        text,
  position    text,
  logged_in_at timestamptz DEFAULT now(),
  user_agent  text
);

CREATE TABLE IF NOT EXISTS performance_evaluations (
  id                  bigint    NOT NULL PRIMARY KEY,
  employee_name       text      NOT NULL,
  evaluator_name      text      NOT NULL,
  rating_knowledge    smallint,
  rating_quality      smallint,
  rating_productivity smallint,
  rating_attendance   smallint,
  rating_teamwork     smallint,
  overall_rating      numeric,
  comments            text,
  evaluated_at        timestamptz DEFAULT now(),
  q1  integer, q2  integer, q3  integer, q4  integer, q5  integer,
  q6  integer, q7  integer, q8  integer, q9  integer, q10 integer,
  q11 integer, q12 integer, q13 integer, q14 integer, q15 integer,
  q16 integer, q17 integer, q18 integer, q19 integer, q20 integer,
  q21 integer, q22 integer, q23 integer, q24 integer, q25 integer
);


-- ========================
-- STEP 3 — INSERT DATA
-- ========================

-- ------------------------------------------------------------
-- profiles (32 rows)
-- ------------------------------------------------------------
INSERT INTO profiles
  (id, username, full_name, department, password, security_question, security_answer, is_admin, created_at, position)
VALUES
  ('8dd3eca3-cbee-4817-a785-0e0f7cfe428d','admin','Administrator','admin','MTIzNDU2','pet','admin',true,'2026-06-22 08:36:24.297755',NULL),
  ('8f304524-3dae-408d-b304-44a85c7d5569','milan','toni','it','MTIzNDU2','pet','meow',true,'2026-06-22 08:41:59.382169','IT Assistant'),
  ('2e3d28a9-96ff-49be-80d5-c1b5a906fde3','accounting_supervisor','ACCOUNTING','accounting','MTIzNDU2','pet','brdc',false,'2026-07-08 05:49:29.197381','Accounting Supervisor'),
  ('2277a88e-25f6-4cf4-95dc-224cd502e2ed','accstaff','ACCOUNTING STAFF','accounting','MTIzNDU2','pet','brdc',false,'2026-07-08 05:52:20.003986','Accounting Staff'),
  ('acd4d47c-c83b-46b6-bb0b-ae6e2ec7d488','juliet','Juliet Cabasog','accounting','MTIzNDU2','pet','brdc',false,'2026-07-11 01:52:56.347151','Accounting Assistant'),
  ('59fd395e-ff0f-4a23-a660-986db89e4601','philline','Myra Philline Pascual','accounting','MTIzNDU2','pet','brdc',false,'2026-07-11 01:54:01.568368','Accounting Assistant'),
  ('fe05cb5a-bd90-4b9e-9a8d-459a86697601','ericka','Ericka Merilles','accounting','MTIzNDU2','pet','brdc',false,'2026-07-11 01:55:18.235472','Accounting Staff'),
  ('c4925a6f-1519-4c1f-b15f-16732ee176f5','maerhen','Maerhen Ventura','accounting','MTIzNDU2','pet','brdc',false,'2026-07-11 01:57:10.464685','Accounting Assistant'),
  ('3150cd16-0eea-4f74-bce3-37d1e2c73797','nicole','Nicole Guia','accounting','MTIzNDU2','pet','brdc',false,'2026-07-11 01:57:46.989383','Accounting Assistant'),
  ('f3a08df2-4fcf-4ae8-a9bd-5748122878d6','bhing','Ruby Marie Coralde','accounting','MTIzNDU2','pet','brdc',false,'2026-07-11 01:58:59.791488','Accounting Assistant Supervisor'),
  ('8d1a144d-e0cd-496f-8143-9d7b4cb427e7','ruth','Ma. Ruth Delos Angeles','purchasing','MTIzNDU2','pet','brdc',false,'2026-07-11 02:00:40.746704','Purchasing Supervisor'),
  ('fe178af7-63e0-46b6-926f-f5727e5d65df','rica','Victoria Rica Lindo','purchasing','MTIzNDU2','pet','brdc',false,'2026-07-11 02:01:25.898246','Purchasing Assistant'),
  ('337a7bc7-3f51-48d0-baf2-d354b3061c81','dhenmarc','Dhenmarc Lustina','purchasing','MTIzNDU2','pet','brdc',false,'2026-07-11 02:01:58.728788','Purchasing Assistant'),
  ('705eadd0-9fcf-4c3b-8ddd-1e87cfd7bc1b','evelyn','Evelyn Baliad','hr','MTIzNDU2','pet','brdc',true,'2026-07-11 02:03:54.753652','HR and Admin Manager'),
  ('fcacc74b-dd30-4f99-b1c2-2f6580fd7ad1','eden','Edenel Deborah Barerra','hr','MTIzNDU2','pet','brdc',true,'2026-07-11 02:04:41.995581','Recruitment Supervisor'),
  ('c362e097-2d83-48e1-87eb-abf30df373b9','dianne','Dianne Mae Bilaro','hr','MTIzNDU2','pet','brdc',true,'2026-07-11 02:05:26.938341','HR Assistant'),
  ('a44d74d6-8066-4609-9216-f7784eaff8d9','cheza','Cheza Fave Paredes','hr','MTIzNDU2','pet','brdc',true,'2026-07-11 02:06:03.791862','Recruitment Staff'),
  ('64878834-3a95-4fa0-8e12-926122ea549d','toni','Toni Milan Calayag','it','MTIzNDU2','pet','brdc',true,'2026-07-11 02:06:47.813136','IT Assistant'),
  ('829d483c-4991-4faf-94eb-914a1c0c0735','johson','Johson Laparan','it','MTIzNDU2','pet','brdc',true,'2026-07-11 02:07:28.628236','IT Manager'),
  ('e47e2a3c-0d55-438a-a16d-3057eea1ecf5','mark','Mark Kevin Pante','it','MTIzNDU2','pet','brdc',true,'2026-07-11 02:08:05.720578','IT Assistant'),
  ('75014c05-2bc4-4e7f-a7eb-f8970416d686','jonathan','Jonathan Marasigan','cmg','MTIzNDU2','pet','brdc',false,'2026-07-11 02:11:47.933576','Operations Manager'),
  ('edddc2ce-e038-484a-a137-073f509e2354','ellen','Ellen Joy Cabase','cmg','MTIzNDU2','pet','brdc',false,'2026-07-11 02:12:45.206808','Admin Assistant'),
  ('993671aa-2696-497e-974a-5447559d78a6','christine','Christine Jhoi Velasco','cmg','MTIzNDU2','pet','brdc',false,'2026-07-11 02:14:08.309103','Admin Officer'),
  ('e8a04cc8-9d65-465e-bde1-91b6b32a3132','kristina','Kristina Marie Manalo','auditor','MTIzNDU2','pet','brdc',false,'2026-07-11 03:39:01.950674','Field Auditor -Manila'),
  ('9d0fb1e5-9894-4690-99e6-01554262f2d5','levy','Levy Cave Motil','auditor','MTIzNDU2','pet','brdc',false,'2026-07-11 03:44:28.842088','Field Auditor -Rizal'),
  ('aa2656ea-454c-494d-8b65-5424fbe5416b','joseph','Mark Joseph Virina','auditor','MTIzNDU2','pet','brdc',false,'2026-07-11 03:46:10.60609','Field Auditor -North'),
  ('a98878fc-b7db-4893-b213-162b5bc5aef7','joselita','Joselita S. Calangian','neobros','MTIzNDU2','pet','brdc',false,'2026-07-13 06:20:27.222934','Admin Assistant'),
  ('dae6d11e-6dc5-4055-ae79-0e1e69d0ec89','generoso','Generoso Ubaldo','neobros','MTIzNDU2','pet','brdc',false,'2026-07-13 06:21:06.063585','Sales and Operation Manager'),
  ('358ccea2-cd8c-44f3-bd1d-35fe902056d0','samuel','Samuel Seron Jr','neobros','MTIzNDU2','pet','brdc',false,'2026-07-13 06:21:39.950805','Pump Technician'),
  ('0fdd5f50-cf12-4d13-8019-1fe666c9ece7','ronalyn','Ronalyn Rosales','exelhaul','MTIzNDU2','pet','brdc',false,'2026-07-13 06:29:55.372754','Admin Assistant'),
  ('d58ea34f-c9ac-4488-a817-5ef0ab83abc4','darwin','Darwin Clark De Guzman','exelhaul','MTIzNDU2','pet','brdc',false,'2026-07-13 06:30:46.044288','Transport Manager'),
  ('be8fcada-a592-494c-8010-c2c4170b8f57','cristina','Ma. Cristina Joy Torilla','exelhaul','MTIzNDU2','pet','brdc',false,'2026-07-13 06:32:33.122929','Customer Service Relation Supervisor');

-- ------------------------------------------------------------
-- birthdays (33 rows)
-- ------------------------------------------------------------
INSERT INTO birthdays (id, name, dept, bday, start_date, created_at) VALUES
  (1,'Dhenmarc','all','06-26','2026-06-19','2026-06-26 02:56:17.569205+00'),
  (2,'toni','all','15-5',NULL,'2026-07-02 09:15:08.557288+00'),
  (3,'Toni','it','07-2',NULL,'2026-07-02 09:19:49.079415+00'),
  (4,'ACCOUNTING','accounting',NULL,'2026-09-11','2026-07-08 05:49:29.41934+00'),
  (5,'ACCOUNTING STAFF','accounting',NULL,'2026-07-08','2026-07-08 05:52:20.207286+00'),
  (6,'Juliet Cabasog','accounting',NULL,'2025-04-28','2026-07-11 01:52:56.517815+00'),
  (7,'Myra Philline Pascual','accounting',NULL,'2024-09-09','2026-07-11 01:54:01.699117+00'),
  (8,'Ericka Merilles','accounting',NULL,'2026-05-25','2026-07-11 01:55:18.355315+00'),
  (9,'Maerhen Ventura','accounting',NULL,'2026-05-04','2026-07-11 01:57:10.607694+00'),
  (10,'Nicole Guia','accounting',NULL,'2026-05-13','2026-07-11 01:57:47.102652+00'),
  (11,'Ruby Marie Coralde','accounting',NULL,'2025-04-02','2026-07-11 01:58:59.937052+00'),
  (12,'Ma. Ruth Delos Angeles','purchasing',NULL,'2025-07-09','2026-07-11 02:00:40.892274+00'),
  (13,'Victoria Rica Lindo','purchasing',NULL,'2025-06-16','2026-07-11 02:01:26.058141+00'),
  (14,'Dhenmarc Lustina','purchasing',NULL,'2025-02-24','2026-07-11 02:01:58.876034+00'),
  (15,'Evelyn Baliad','hr',NULL,'2021-11-23','2026-07-11 02:03:54.896467+00'),
  (16,'Edenel Deborah Barerra','hr',NULL,'2024-04-04','2026-07-11 02:04:42.138663+00'),
  (17,'Dianne Mae Bilaro','hr',NULL,'2025-10-20','2026-07-11 02:05:27.08965+00'),
  (18,'Cheza Fave Paredes','hr',NULL,'2025-07-02','2026-07-11 02:06:03.944239+00'),
  (19,'Toni Milan Calayag','it',NULL,'2025-05-28','2026-07-11 02:06:47.955346+00'),
  (20,'Johson Laparan','it',NULL,'2022-02-16','2026-07-11 02:07:28.737836+00'),
  (21,'Mark Kevin Pante','it',NULL,'2025-03-10','2026-07-11 02:08:05.824547+00'),
  (22,'Jonathan Marasigan','cmg',NULL,'2025-09-22','2026-07-11 02:11:48.107335+00'),
  (23,'Ellen Joy Cabase','cmg',NULL,'2026-06-01','2026-07-11 02:12:45.319339+00'),
  (24,'Christine Jhoi Velasco','cmg',NULL,'2026-05-25','2026-07-11 02:14:08.433927+00'),
  (25,'Kristina Marie Manalo','auditor',NULL,'2025-09-02','2026-07-11 03:39:02.106571+00'),
  (26,'Levy Cave Motil','auditor',NULL,'2024-02-02','2026-07-11 03:44:28.960355+00'),
  (27,'Mark Joseph Virina','auditor',NULL,'2025-10-20','2026-07-11 03:46:10.76635+00'),
  (28,'Joselita S. Calangian','neobros',NULL,'2025-11-04','2026-07-13 06:20:27.608532+00'),
  (29,'Generoso Ubaldo','neobros',NULL,'2017-04-24','2026-07-13 06:21:06.256412+00'),
  (30,'Samuel Seron Jr','neobros',NULL,'2022-05-12','2026-07-13 06:21:40.159825+00'),
  (31,'Ronalyn Rosales','exelhaul',NULL,'2025-09-05','2026-07-13 06:29:55.509568+00'),
  (32,'Darwin Clark De Guzman','exelhaul',NULL,'2017-08-01','2026-07-13 06:30:46.188104+00'),
  (33,'Ma. Cristina Joy Torilla','exelhaul',NULL,'2017-06-02','2026-07-13 06:32:33.266719+00');

-- ------------------------------------------------------------
-- directory_entries (10 rows)
-- ------------------------------------------------------------
INSERT INTO directory_entries (id, name, position, dept, email, phone, created_at) VALUES
  (1, 'Robert Dungca',          'Retail Operations Manager',                  'SmartFuels', NULL, '+639088140422', '2026-06-26 06:51:46.989618+00'),
  (2, 'Rachel Dionisio',        'Assistant Retail Operations',                'SmartFuels', NULL, '+639985893601', '2026-06-26 06:51:46.989618+00'),
  (3, 'Elfred Adalin',          'Assistant Area Supervisor - Manila Area',    'SmartFuels', NULL, '+639681614534', '2026-06-26 06:51:46.989618+00'),
  (4, 'Marie Shyne Norcio',     'Assistant Area Supervisor - Rizal Area',     'SmartFuels', NULL, '+639285073529', '2026-06-26 06:51:46.989618+00'),
  (5, 'Ann Bernadette Dela Cruz','Area Manager - North Area',                 'SmartFuels', NULL, '+639088140619', '2026-06-26 06:51:46.989618+00'),
  (6, 'Jean Jelyn Belen',       'Area Manager - South Area',                  'SmartFuels', NULL, '+639764419444', '2026-06-26 06:51:46.989618+00'),
  (7, 'Maryjane Cueto',         'Assistant Area Supervisor - South',          'SmartFuels', NULL, '+639399363387', '2026-06-26 06:51:46.989618+00'),
  (8, 'Katherine Nazario',      'Assistant Area Supervisor - North Area',     'SmartFuels', NULL, '+639088140650', '2026-06-26 06:51:46.989618+00'),
  (9, 'Marites Costillas',      'SF Admin Assistant',                         'SmartFuels', NULL, '+639399749384', '2026-06-26 06:51:46.989618+00'),
  (10,'Aiza Babida',            'Compliance Officer',                         'SmartFuels', NULL, '+639088140696', '2026-06-26 06:51:46.989618+00');

-- ------------------------------------------------------------
-- dept_announcements (4 rows)
-- ------------------------------------------------------------
INSERT INTO dept_announcements (id, title, body, dept, posted_by, posted_at, pinned, priority) VALUES
  (1, 'hello',             'asdsadasdas',                          'accounting', 'Renzy',      '2026-07-02 06:32:14.586582+00', true,  'info'),
  (2, 'TEST',              'HELLO MGA',                            'accounting', 'Renzy',      '2026-07-02 07:08:23.011364+00', true,  'info'),
  (3, 'TESTTING',          'BLAH BLAHH',                           'accounting', 'Renzy',      '2026-07-02 08:16:13.008653+00', false, 'info'),
  (4, 'Announcement Guys', 'TESTING ANNOUNCEMENT ACCOUNTING ONLY', 'accounting', 'ACCOUNTING', '2026-07-13 07:12:38.263018+00', true,  'fyi');

SELECT setval('dept_announcements_id_seq', 4);

-- ------------------------------------------------------------
-- broadcast_alert (1 row)
-- ------------------------------------------------------------
INSERT INTO broadcast_alert (id, message, type, is_active, updated_at, updated_by) VALUES
  (1, '', 'danger', false, '2026-07-02 09:23:29.412+00', 'toni');

-- ------------------------------------------------------------
-- it_systems (6 rows)
-- ------------------------------------------------------------
INSERT INTO it_systems (id, name, category, status, note, sort_order, updated_at, updated_by) VALUES
  ('c66cb49c-5558-42e0-8e51-df1624fe9fb9', 'Internet / Network',       'Infrastructure', 'online', '', 1, '2026-07-02 09:23:36.111+00',    'toni'),
  ('0dd2ae4f-040a-43f6-9c4f-61e6316abdf8', 'Email (Microsoft 365)',    'Communication',  'online', '', 2, '2026-06-27 02:29:41.698262+00', ''),
  ('d4fe4e98-43e5-4520-b627-1f6e38a46ae6', 'HR System (PayrollHero)',  'HR & Payroll',   'online', '', 3, '2026-06-27 02:29:41.698262+00', ''),
  ('7dc8b1d1-bce3-42e6-98a6-9090fee9447c', 'CMMS Portal',              'Operations',     'online', '', 4, '2026-06-27 02:29:41.698262+00', ''),
  ('75daf021-15f0-4dad-8a7a-7d30c9dfbe86', 'File Server / SharePoint', 'Storage',        'online', '', 5, '2026-06-27 02:29:41.698262+00', ''),
  ('c548115b-e410-4da8-8201-db026fc63556', 'CCTV / Access Control',    'Security',       'online', '', 6, '2026-06-27 02:29:41.698262+00', '');

-- ------------------------------------------------------------
-- announcement_acknowledgements (10 rows)
-- ------------------------------------------------------------
INSERT INTO announcement_acknowledgements
  (id, announcement_id, username, full_name, dept, position, acknowledged_at)
VALUES
  (1,  2, 'tons',                 'toni',           'accounting', 'Accounting Assistant', '2026-07-03 02:14:02.876316+00'),
  (2,  1, 'tons',                 'toni',           'accounting', 'Accounting Assistant', '2026-07-03 02:14:08.9908+00'),
  (3,  3, 'tons',                 'toni',           'accounting', 'Accounting Assistant', '2026-07-03 02:14:09.954471+00'),
  (4,  2, 'mark',                 'Renzy',          'accounting', 'Accounting Supervisor','2026-07-03 02:19:11.238832+00'),
  (5,  3, 'mark',                 'Renzy',          'accounting', 'Accounting Supervisor','2026-07-03 05:01:38.649616+00'),
  (6,  1, 'mark',                 'Renzy',          'accounting', 'Accounting Supervisor','2026-07-03 05:01:38.885163+00'),
  (7,  2, 'accounting_supervisor','ACCOUNTING',     'accounting', 'Accounting Supervisor','2026-07-08 06:26:53.849095+00'),
  (8,  3, 'juliet',               'Juliet Cabasog', 'accounting', 'Accounting Assistant', '2026-07-13 07:13:24.904656+00'),
  (9,  1, 'juliet',               'Juliet Cabasog', 'accounting', 'Accounting Assistant', '2026-07-13 07:13:26.795362+00'),
  (10, 2, 'juliet',               'Juliet Cabasog', 'accounting', 'Accounting Assistant', '2026-07-13 07:13:27.948155+00');

SELECT setval('announcement_acknowledgements_id_seq', 10);

-- ------------------------------------------------------------
-- login_logs (32 rows)
-- ------------------------------------------------------------
INSERT INTO login_logs (id, username, full_name, dept, position, logged_in_at, user_agent) VALUES
  (1,  'mark',                'Renzy',                 'accounting', 'Accounting Supervisor',  '2026-07-03 02:29:38.299217+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0'),
  (2,  'mark',                'Renzy',                 'accounting', 'Accounting Supervisor',  '2026-07-03 02:52:53.174192+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0'),
  (3,  'mark',                'Renzy',                 'accounting', 'Accounting Supervisor',  '2026-07-03 03:33:44.883231+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0'),
  (4,  'milan',               'toni',                  'it',         'IT Assistant',           '2026-07-03 03:41:47.053523+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0'),
  (5,  'mark',                'Renzy',                 'accounting', 'Accounting Supervisor',  '2026-07-03 05:01:25.561118+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0'),
  (6,  'tons',                'toni',                  'accounting', 'Accounting Assistant',   '2026-07-03 05:02:16.444469+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0'),
  (7,  'tonii',               'toni',                  'purchasing', 'Purchasing Supervisor',  '2026-07-03 05:19:09.613422+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0'),
  (8,  'milan',               'toni',                  'it',         'IT Assistant',           '2026-07-03 05:19:29.873181+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0'),
  (9,  'milan',               'toni',                  'it',         'IT Assistant',           '2026-07-03 05:26:44.347823+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0'),
  (10, 'milan',               'toni',                  'it',         'IT Assistant',           '2026-07-03 06:58:04.69735+00',  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0'),
  (11, 'milan',               'toni',                  'it',         'IT Assistant',           '2026-07-03 07:04:01.074181+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0'),
  (12, 'cmg',                 'CMG',                   'cmg',        'General Manager',        '2026-07-03 09:33:15.190811+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36'),
  (13, 'milan',               'toni',                  'it',         'IT Assistant',           '2026-07-03 09:42:49.99002+00',  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0'),
  (14, 'hr2',                 'hr2',                   'hr',         'Assistant HR Manager',   '2026-07-06 00:37:10.768142+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0'),
  (15, 'admin',               'Administrator',         'admin',      NULL,                     '2026-07-06 04:40:04.503407+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0'),
  (16, 'admin',               'Administrator',         'admin',      NULL,                     '2026-07-06 04:44:08.875315+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0'),
  (17, 'admin',               'Administrator',         'admin',      NULL,                     '2026-07-06 05:38:41.546718+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0'),
  (18, 'milan',               'toni',                  'it',         'IT Assistant',           '2026-07-06 06:28:51.151378+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0'),
  (19, 'milan',               'toni',                  'it',         'IT Assistant',           '2026-07-11 03:21:51.974328+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0'),
  (20, 'milan',               'toni',                  'it',         'IT Assistant',           '2026-07-11 05:30:54.760161+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0'),
  (21, 'eden',                'Edenel Deborah Barerra','hr',         'Recruitment Supervisor', '2026-07-11 06:00:14.933457+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0'),
  (22, 'juliet',              'Juliet Cabasog',        'accounting', 'Accounting Assistant',   '2026-07-13 07:10:43.950326+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0'),
  (23, 'milan',               'toni',                  'it',         'IT Assistant',           '2026-07-13 07:10:45.111845+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0'),
  (24, 'juliet',              'Juliet Cabasog',        'accounting', 'Accounting Assistant',   '2026-07-13 07:11:07.430981+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0'),
  (25, 'accounting_supervisor','ACCOUNTING',           'accounting', 'Accounting Supervisor',  '2026-07-13 07:36:17.812557+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0'),
  (26, 'accounting_supervisor','ACCOUNTING',           'accounting', 'Accounting Supervisor',  '2026-07-13 07:54:58.127026+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0'),
  (27, 'accounting_supervisor','ACCOUNTING',           'accounting', 'Accounting Supervisor',  '2026-07-13 07:56:13.622916+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0'),
  (28, 'evelyn',              'Evelyn Baliad',         'hr',         'HR and Admin Manager',   '2026-07-13 07:56:45.227605+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0'),
  (29, 'milan',               'toni',                  'it',         'IT Assistant',           '2026-07-15 08:27:53.4901+00',   'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0'),
  (30, 'juliet',              'Juliet Cabasog',        'accounting', 'Accounting Assistant',   '2026-07-16 08:09:06.82511+00',  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36'),
  (31, 'milan',               'toni',                  'it',         'IT Assistant',           '2026-07-17 02:39:33.163993+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0'),
  (32, 'milan',               'toni',                  'it',         'IT Assistant',           '2026-07-17 08:21:54.268784+00', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0');

SELECT setval('login_logs_id_seq', 32);


-- ============================================================
-- DONE — All 13 tables created, 8 tables populated.
--
-- NEXT STEP — Storage bucket:
--   Go to Storage > New bucket > Name: MEMOS > Public: ON
--   (Bucket data cannot be migrated via SQL)
-- ============================================================
