USE pdns;

BEGIN;
INSERT INTO domains (name, type) VALUES ('a.c.m.e', 'NATIVE');
INSERT INTO domains (name, type) VALUES ('20.168.192.in-addr.arpa', 'NATIVE');
INSERT INTO records (domain_id, name, content, type, ttl ,prio) VALUES (1, 'a.c.m.e', 'ns1.overlord001.a.c.m.e jpoppe@ebay.com 2011050900 86400 7200 3600000 86400', 'SOA', 86400, NULL);
INSERT INTO records (domain_id, name, content, type, ttl ,prio) VALUES (1, 'a.c.m.e', 'ns1.overlord001.a.c.m.e', 'NS', 86400, NULL);
INSERT INTO records (domain_id, name, content, type, ttl ,prio) VALUES (1, 'a.c.m.e', 'ns2.overlord002.a.c.m.e', 'NS', 86400, NULL);
INSERT INTO records (domain_id, name, content, type, ttl ,prio) VALUES (1, 'ns1.overlord001.a.c.m.e', '192.168.20.1', 'A', 120, NULL);
INSERT INTO records (domain_id, name, content, type, ttl ,prio) VALUES (1, 'ns2.overlord002.a.c.m.e', '192.168.20.2', 'A', 120, NULL);
INSERT INTO records (domain_id, name, content, type, ttl ,prio) VALUES (1, 'overlord001.a.c.m.e', 'mail.overlord001.a.c.m.e', 'MX', 120, 10);
INSERT INTO records (domain_id, name, content, type, ttl ,prio) VALUES (1, 'overlord002.a.c.m.e', 'mail.overlord002.a.c.m.e', 'MX', 120, 20);
INSERT INTO records (domain_id, name, content, type, ttl ,prio) VALUES (1, 'overlord001.a.c.m.e', '192.168.20.1', 'A', 120, NULL);
INSERT INTO records (domain_id, name, content, type, ttl ,prio) VALUES (1, 'overlord002.a.c.m.e', '192.168.20.2', 'A', 120, NULL);
INSERT INTO records (domain_id, name, content, type, ttl ,prio) VALUES (2, '1.20.168.192.in-addr.arpa', 'overlord001.a.c.m.e', 'PTR', NULL, NULL);
INSERT INTO records (domain_id, name, content, type, ttl ,prio) VALUES (2, '2.20.168.192.in-addr.arpa', 'overlord002.a.c.m.e', 'PTR', NULL, NULL);
COMMIT;
