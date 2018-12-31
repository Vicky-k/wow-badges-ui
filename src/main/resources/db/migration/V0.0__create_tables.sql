CREATE SEQUENCE serial_sequence;

CREATE TABLE badge
(
  badge_id bigint NOT NULL,
  status character varying(255) ,
  used_flag character varying(255) ,
  CONSTRAINT badge_pkey PRIMARY KEY (badge_id)
);

CREATE TABLE badge_visitor_mapping
(
  id bigint NOT NULL,
  badge_id bigint,
  check_in_time character varying(255) ,
  check_out_time character varying(255) ,
  first_name character varying(255) ,
  last_name character varying(255) ,
  phone_number character varying(255) ,
  visit_date date,
  visitor_id bigint,
  CONSTRAINT badge_visitor_mapping_pkey PRIMARY KEY (id)
);
