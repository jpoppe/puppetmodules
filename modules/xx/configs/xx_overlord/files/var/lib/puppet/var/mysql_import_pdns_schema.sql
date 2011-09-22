CREATE table domains (
 id               INT auto_increment,
 name             VARCHAR(255) NOT NULL,
 master           VARCHAR(20) DEFAULT NULL,
 last_check       INT DEFAULT NULL,
 type             VARCHAR(6) NOT NULL,
 notified_serial  INT DEFAULT NULL, 
 account          VARCHAR(40) DEFAULT NULL,
 primary key (id)
)type=InnoDB;

CREATE UNIQUE INDEX name_index ON domains(name);

CREATE TABLE records (
  id              INT auto_increment,
  domain_id       INT DEFAULT NULL,
  name            VARCHAR(255) DEFAULT NULL,
  type            VARCHAR(6) DEFAULT NULL,
  content         VARCHAR(255) DEFAULT NULL,
  ttl             INT DEFAULT NULL,
  prio            INT DEFAULT NULL,
  change_date     INT DEFAULT NULL,
  primary key(id),
  CONSTRAINT `records_ibfk_1` FOREIGN KEY (`domain_id`) REFERENCES `domains`
(`id`) ON DELETE CASCADE
)type=InnoDB;

CREATE INDEX rec_name_index ON records(name);
CREATE INDEX nametype_index ON records(name,type);
CREATE INDEX domain_id ON records(domain_id);

CREATE TABLE supermasters (
  ip          VARCHAR(25) NOT NULL, 
  nameserver  VARCHAR(255) NOT NULL, 
  account     VARCHAR(40) DEFAULT NULL
)type=InnoDB;

CREATE TABLE domainmetadata (
	 id              INT auto_increment,
	 domain_id       INT NOT NULL,
	 kind            VARCHAR(16),
	 content        TEXT,
	 primary key(id)
)type=InnoDB;

CREATE TABLE cryptokeys (
	 id             INT auto_increment,
	 domain_id      INT DEFAULT NULL,
	 flags          INT NOT NULL,
	 active         BOOL,
	 content        TEXT,
	 primary key(id)
)type=InnoDB;

ALTER TABLE records ADD ordername      VARCHAR(255);
ALTER TABLE records ADD auth bool;
CREATE INDEX orderindex ON records(ordername);

CREATE TABLE tsigkeys (
	 id             INT auto_increment,
	 name           VARCHAR(255), 
	 algorithm      VARCHAR(255),
	 secret         VARCHAR(255),
	 primary key(id)
)type=InnoDB;

CREATE UNIQUE INDEX namealgoindex ON tsigkeys(name, algorithm);

ALTER TABLE records CHANGE COLUMN type type VARCHAR(10);
