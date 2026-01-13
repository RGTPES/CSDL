drop database if exists social_network_mini;
create database social_network_mini;
use social_network_mini;
set foreign_key_checks = 0;
create table users (
  user_id int auto_increment primary key,
  username varchar(50) not null unique,
  password varchar(255) not null,
  email varchar(100) not null unique,
  created_at datetime default current_timestamp
) engine=innodb;

create table posts (
  post_id int auto_increment primary key,
  user_id int not null,
  content text not null,
  created_at datetime default current_timestamp,
  constraint fk_posts_users foreign key (user_id) references users(user_id)
    on update cascade 
    on delete cascade
) engine=innodb;

create table comments (
  comment_id int auto_increment primary key,
  post_id int not null,
  user_id int not null,
  content text not null,
  created_at datetime default current_timestamp,
  constraint fk_comments_posts foreign key (post_id) references posts(post_id)
    on update cascade 
    on delete cascade,
  constraint fk_comments_users foreign key (user_id) references users(user_id)
    on update cascade 
    on delete cascade
) engine=innodb;

create table friends (
  user_id int not null,
  friend_id int not null,
  status varchar(20) not null,
  created_at datetime default current_timestamp,
  primary key (user_id, friend_id),
  constraint fk_friends_user foreign key (user_id) references users(user_id)
    on update cascade on delete cascade,
  constraint fk_friends_friend foreign key (friend_id) references users(user_id)
    on update cascade on delete cascade,
  constraint chk_friends_status check (status in ('pending','accepted'))
) engine=innodb;


create table likes (
  user_id int not null,
  post_id int not null,
  created_at datetime default current_timestamp,
  primary key (user_id, post_id),
  constraint fk_likes_users foreign key (user_id) references users(user_id)
    on update cascade 
    on delete cascade,
  constraint fk_likes_posts foreign key (post_id) references posts(post_id)
    on update cascade 
    on delete cascade
) engine=innodb;

create index idx_posts_user_created on posts(user_id, created_at);
create index idx_comments_post_created on comments(post_id, created_at);
create index idx_comments_user_created on comments(user_id, created_at);
create index idx_friends_status on friends(status);
create index idx_likes_post on likes(post_id);

set foreign_key_checks = 1;

-- =========================
-- seed data: users (18)
-- =========================
insert into users (username, password, email, created_at) values
('an.nguyen',   'pass123', 'an.nguyen@gmail.com',   '2026-01-01 09:10:00'),
('binh.tran',   'pass123', 'binh.tran@gmail.com',   '2026-01-01 09:12:00'),
('chi.le',      'pass123', 'chi.le@gmail.com',      '2026-01-01 09:15:00'),
('dung.pham',   'pass123', 'dung.pham@gmail.com',   '2026-01-02 10:00:00'),
('em.hoang',    'pass123', 'em.hoang@gmail.com',    '2026-01-02 10:05:00'),
('giang.vo',    'pass123', 'giang.vo@gmail.com',    '2026-01-02 10:06:00'),
('hieu.do',     'pass123', 'hieu.do@gmail.com',     '2026-01-03 08:00:00'),
('hoa.ngo',     'pass123', 'hoa.ngo@gmail.com',     '2026-01-03 08:03:00'),
('khanh.bui',   'pass123', 'khanh.bui@gmail.com',   '2026-01-03 08:06:00'),
('lam.nguyen',  'pass123', 'lam.nguyen@gmail.com',  '2026-01-03 08:10:00'),
('minh.tran',   'pass123', 'minh.tran@gmail.com',   '2026-01-04 11:00:00'),
('ngoc.le',     'pass123', 'ngoc.le@gmail.com',     '2026-01-04 11:05:00'),
('phuc.pham',   'pass123', 'phuc.pham@gmail.com',   '2026-01-05 12:20:00'),
('quang.vo',    'pass123', 'quang.vo@gmail.com',    '2026-01-05 12:25:00'),
('son.do',      'pass123', 'son.do@gmail.com',      '2026-01-06 14:00:00'),
('thao.ngo',    'pass123', 'thao.ngo@gmail.com',    '2026-01-06 14:02:00'),
('tuan.bui',    'pass123', 'tuan.bui@gmail.com',    '2026-01-07 15:30:00'),
('vy.nguyen',   'pass123', 'vy.nguyen@gmail.com',   '2026-01-07 15:35:00');

-- ====================================
-- friends (có pending + accepted, 2 chiều cho accepted)
-- ====================================
insert into friends (user_id, friend_id, status, created_at) values
(1, 2, 'accepted', '2026-01-02 09:00:00'),
(2, 1, 'accepted', '2026-01-02 09:00:00'),
(1, 3, 'accepted', '2026-01-02 09:05:00'),
(3, 1, 'accepted', '2026-01-02 09:05:00'),
(2, 4, 'accepted', '2026-01-03 10:10:00'),
(4, 2, 'accepted', '2026-01-03 10:10:00'),
(3, 5, 'accepted', '2026-01-03 10:15:00'),
(5, 3, 'accepted', '2026-01-03 10:15:00'),
(4, 6, 'accepted', '2026-01-03 10:20:00'),
(6, 4, 'accepted', '2026-01-03 10:20:00'),
(5, 6, 'accepted', '2026-01-03 10:30:00'),
(6, 5, 'accepted', '2026-01-03 10:30:00'),
(7, 8, 'accepted', '2026-01-04 09:00:00'),
(8, 7, 'accepted', '2026-01-04 09:00:00'),
(7, 9, 'accepted', '2026-01-04 09:10:00'),
(9, 7, 'accepted', '2026-01-04 09:10:00'),
(8, 10, 'accepted', '2026-01-04 09:20:00'),
(10, 8, 'accepted', '2026-01-04 09:20:00'),
(9, 10, 'accepted', '2026-01-04 09:25:00'),
(10, 9, 'accepted', '2026-01-04 09:25:00'),

-- pending (thường chỉ 1 chiều)
(11, 12, 'pending', '2026-01-05 08:10:00'),
(13, 11, 'pending', '2026-01-05 08:12:00'),
(14, 15, 'pending', '2026-01-06 10:00:00'),
(16, 14, 'pending', '2026-01-06 10:05:00'),
(17, 18, 'pending', '2026-01-07 09:00:00');

-- =========================
-- posts (36)
-- =========================
insert into posts (user_id, content, created_at) values
(1,  'hôm nay học sql view và index',                      '2026-01-02 08:00:00'),
(2,  'ai có tài liệu về stored procedure không',           '2026-01-02 08:05:00'),
(3,  'mình vừa tối ưu query bằng index, nhanh hẳn',        '2026-01-02 08:10:00'),
(4,  'làm mini project social network khá vui',            '2026-01-02 08:20:00'),
(5,  'mọi người share kinh nghiệm thiết kế erd nhé',        '2026-01-02 08:30:00'),
(6,  'hôm nay code mysql workbench hơi lag',               '2026-01-02 09:00:00'),
(7,  'mình đang viết view để ẩn password',                 '2026-01-03 07:30:00'),
(8,  'join nhiều bảng thì cần index cột foreign key',       '2026-01-03 07:40:00'),
(9,  'cách đặt tên index chuẩn là gì nhỉ',                  '2026-01-03 07:50:00'),
(10, 'tạo dữ liệu seed cho project mất thời gian ghê',      '2026-01-03 08:00:00'),
(11, 'hôm nay test procedure notify friends',              '2026-01-04 09:00:00'),
(12, 'mình thích dùng constraint check cho status',         '2026-01-04 09:05:00'),
(13, 'ai bị lỗi foreign key missing index chưa',            '2026-01-04 09:10:00'),
(14, 'comment nhiều thì nên paginate',                      '2026-01-04 09:20:00'),
(15, 'likes cũng cần unique để tránh trùng',                '2026-01-04 09:30:00'),
(16, 'đang học cách viết trigger',                          '2026-01-05 10:00:00'),
(17, 'tối ưu bằng composite index rất hữu ích',             '2026-01-05 10:10:00'),
(18, 'hôm nay mình làm xong erd rồi',                        '2026-01-05 10:20:00'),

(1,  'ai rảnh review schema giúp mình',                     '2026-01-06 08:00:00'),
(2,  'stored procedure có out param khá hay',               '2026-01-06 08:05:00'),
(3,  'view giúp bảo mật dữ liệu người dùng',                '2026-01-06 08:10:00'),
(4,  'mình thêm index cho created_at để sort nhanh',        '2026-01-06 08:12:00'),
(5,  'thiết kế friends 2 chiều hay 1 chiều nhỉ',            '2026-01-06 08:20:00'),
(6,  'mình đang seed 200 comments',                          '2026-01-06 08:25:00'),
(7,  'cần query top user có nhiều comment nhất',            '2026-01-06 09:00:00'),
(8,  'đừng quên on delete cascade khi test',                '2026-01-06 09:10:00'),
(9,  'ai có mẫu dữ liệu realistic hơn không',               '2026-01-06 09:15:00'),
(10, 'viết report cho project nữa là xong',                 '2026-01-06 09:20:00'),
(11, 'mình đang debug lỗi duplicate key ở likes',           '2026-01-07 11:00:00'),
(12, 'chuẩn bị demo trước lớp thôi',                         '2026-01-07 11:05:00'),
(13, 'có ai muốn thêm bảng notifications không',            '2026-01-07 11:10:00'),
(14, 'cách group by để thống kê tương tác',                 '2026-01-07 11:12:00'),
(15, 'đã xong phần index, giờ đến procedure',               '2026-01-07 11:20:00'),
(16, 'tạo view student-basic kiểu vậy áp vào đây được',      '2026-01-07 11:25:00'),
(17, 'cố lên mọi người',                                     '2026-01-07 11:30:00'),
(18, 'mai nộp bài rồi',                                       '2026-01-07 11:40:00');

-- =========================
-- comments (72)
-- =========================
insert into comments (post_id, user_id, content, created_at) values
(1, 2,  'chuẩn rồi, view rất hữu ích',              '2026-01-02 08:02:00'),
(1, 3,  'nhớ index cột hay filter nữa',             '2026-01-02 08:03:00'),
(2, 1,  'mình có, để mình gửi mẫu',                 '2026-01-02 08:06:00'),
(2, 4,  'procedure dùng delimiter cho đúng',        '2026-01-02 08:08:00'),
(3, 5,  'composite index ok lắm',                   '2026-01-02 08:12:00'),
(3, 6,  'explain để xem plan nhé',                  '2026-01-02 08:13:00'),
(4, 2,  'đúng kiểu thực hành nâng cao',             '2026-01-02 08:22:00'),
(4, 3,  'nhớ ràng buộc foreign key',                '2026-01-02 08:23:00'),
(5, 1,  'erd nên rõ pk-fk',                         '2026-01-02 08:32:00'),
(5, 4,  'thêm crow foot notation là đẹp',           '2026-01-02 08:33:00'),

(6, 7,  'workbench đôi khi nặng thật',              '2026-01-02 09:02:00'),
(6, 8,  'tắt auto-completion thử xem',              '2026-01-02 09:03:00'),
(7, 9,  'view ẩn password là chuẩn bài',            '2026-01-03 07:32:00'),
(7, 10, 'nên chỉ select cột cần thiết',             '2026-01-03 07:33:00'),
(8, 11, 'index fk cột join là bắt buộc',            '2026-01-03 07:42:00'),
(8, 12, 'thêm index created_at nếu hay sort',       '2026-01-03 07:43:00'),
(9, 13, 'idx_<table>_<col> dễ đọc',                 '2026-01-03 07:52:00'),
(9, 14, 'quan trọng là thống nhất convention',      '2026-01-03 07:53:00'),
(10, 15,'seed nhiều thì insert theo batch',         '2026-01-03 08:02:00'),
(10, 16,'hoặc dùng script generate',                '2026-01-03 08:03:00'),

(11, 1, 'notify friends hay đó',                    '2026-01-04 09:02:00'),
(11, 2, 'nhớ không gửi cho chính chủ',              '2026-01-04 09:03:00'),
(12, 3, 'check constraint rất đáng giá',            '2026-01-04 09:07:00'),
(12, 4, 'mysql 8 mới hỗ trợ check tốt hơn',         '2026-01-04 09:08:00'),
(13, 5, 'bị rồi, bảng cha phải có index pk',        '2026-01-04 09:12:00'),
(13, 6, 'nhất là foreign key referenced',           '2026-01-04 09:13:00'),
(14, 7, 'paginate comment cho nhẹ',                 '2026-01-04 09:22:00'),
(14, 8, 'limit offset hoặc keyset',                 '2026-01-04 09:23:00'),
(15, 9, 'likes nên primary key (user_id, post_id)', '2026-01-04 09:32:00'),
(15, 10,'tránh spam like trùng',                    '2026-01-04 09:33:00'),

(16, 11,'trigger cũng hay nhưng cẩn thận',          '2026-01-05 10:02:00'),
(16, 12,'procedure thường đủ dùng',                 '2026-01-05 10:03:00'),
(17, 13,'composite index theo where + order by',    '2026-01-05 10:12:00'),
(17, 14,'đúng, chọn đúng thứ tự cột',               '2026-01-05 10:13:00'),
(18, 15,'erd xong là nhẹ người',                    '2026-01-05 10:22:00'),
(18, 16,'giờ test query thống kê thôi',             '2026-01-05 10:23:00'),

(19, 2, 'để mình review giúp',                      '2026-01-06 08:02:00'),
(19, 3, 'share schema lên nhé',                     '2026-01-06 08:03:00'),
(20, 4, 'out param tiện cho báo cáo',               '2026-01-06 08:07:00'),
(20, 5, 'inout cũng hay',                           '2026-01-06 08:08:00'),
(21, 6, 'view chỉ cho select data public',          '2026-01-06 08:12:00'),
(21, 7, 'đúng rồi, không lộ password',              '2026-01-06 08:13:00'),
(22, 8, 'idx created_at giúp sort nhanh',           '2026-01-06 08:14:00'),
(22, 9, 'nhưng nhớ tradeoff insert',                '2026-01-06 08:15:00'),
(23, 10,'friends 2 chiều dễ query accepted',        '2026-01-06 08:22:00'),
(23, 11,'1 chiều thì cần logic phức tạp hơn',       '2026-01-06 08:23:00'),

(24, 12,'200 comments nghe nhiều đó',               '2026-01-06 08:27:00'),
(24, 13,'bạn seed bằng script là nhanh nhất',       '2026-01-06 08:28:00'),
(25, 14,'top user comment: group by user_id',       '2026-01-06 09:02:00'),
(25, 15,'order by count desc',                      '2026-01-06 09:03:00'),
(26, 16,'cascade xóa test rất tiện',                '2026-01-06 09:12:00'),
(26, 17,'nhưng production thì cân nhắc',            '2026-01-06 09:13:00'),
(27, 18,'mẫu dữ liệu realistic thì thêm timestamp', '2026-01-06 09:17:00'),
(27, 1, 'và nội dung đa dạng hơn',                  '2026-01-06 09:18:00'),

(28, 2, 'report nhớ phần mục tiêu, mô tả',          '2026-01-06 09:22:00'),
(28, 3, 'thêm hình erd nữa là đẹp',                 '2026-01-06 09:23:00'),
(29, 4, 'duplicate key likes do trùng insert',      '2026-01-07 11:02:00'),
(29, 5, 'dùng insert ignore hoặc kiểm tra trước',   '2026-01-07 11:03:00'),
(30, 6, 'demo thì chuẩn bị query thống kê',         '2026-01-07 11:07:00'),
(30, 7, 'explain plan thêm điểm',                   '2026-01-07 11:08:00'),

(31, 8, 'notifications là mở rộng hay',             '2026-01-07 11:12:00'),
(31, 9, 'nhưng đề bài hiện chưa yêu cầu',           '2026-01-07 11:13:00'),
(32, 10,'group by theo user và sum',                '2026-01-07 11:14:00'),
(32, 11,'đúng, join posts/comments',                '2026-01-07 11:15:00'),
(33, 12,'procedure giúp đóng gói logic',            '2026-01-07 11:22:00'),
(33, 13,'tái sử dụng tốt',                          '2026-01-07 11:23:00'),

(34, 14,'áp dụng view-index-procedure là chuẩn',    '2026-01-07 11:26:00'),
(34, 15,'thầy hay chấm phần này',                   '2026-01-07 11:27:00'),
(35, 16,'cố lên',                                   '2026-01-07 11:32:00'),
(35, 17,'sắp xong rồi',                              '2026-01-07 11:33:00'),
(36, 18,'mai nộp thì check lại constraints nhé',    '2026-01-07 11:42:00'),
(36, 1, 'ok bạn',                                   '2026-01-07 11:43:00');

-- =========================
-- likes (90)
-- =========================
insert into likes (user_id, post_id, created_at) values
(2,1,'2026-01-02 08:04:00'), (3,1,'2026-01-02 08:04:30'), (4,1,'2026-01-02 08:05:00'),
(1,2,'2026-01-02 08:06:30'), (3,2,'2026-01-02 08:07:00'), (5,2,'2026-01-02 08:07:30'),
(1,3,'2026-01-02 08:12:30'), (2,3,'2026-01-02 08:12:50'), (6,3,'2026-01-02 08:13:10'),
(2,4,'2026-01-02 08:22:30'), (3,4,'2026-01-02 08:22:40'), (5,4,'2026-01-02 08:22:50'),
(1,5,'2026-01-02 08:32:10'), (4,5,'2026-01-02 08:32:20'), (6,5,'2026-01-02 08:32:30'),

(7,6,'2026-01-02 09:04:00'), (8,6,'2026-01-02 09:04:10'), (9,6,'2026-01-02 09:04:20'),
(9,7,'2026-01-03 07:34:00'), (10,7,'2026-01-03 07:34:10'), (11,7,'2026-01-03 07:34:20'),
(11,8,'2026-01-03 07:44:00'), (12,8,'2026-01-03 07:44:10'), (13,8,'2026-01-03 07:44:20'),
(14,9,'2026-01-03 07:54:00'), (15,9,'2026-01-03 07:54:10'), (16,9,'2026-01-03 07:54:20'),
(15,10,'2026-01-03 08:04:00'), (16,10,'2026-01-03 08:04:10'), (17,10,'2026-01-03 08:04:20'),

(1,11,'2026-01-04 09:04:00'), (2,11,'2026-01-04 09:04:10'), (3,11,'2026-01-04 09:04:20'),
(4,12,'2026-01-04 09:09:00'), (5,12,'2026-01-04 09:09:10'), (6,12,'2026-01-04 09:09:20'),
(7,13,'2026-01-04 09:14:00'), (8,13,'2026-01-04 09:14:10'), (9,13,'2026-01-04 09:14:20'),
(10,14,'2026-01-04 09:24:00'), (11,14,'2026-01-04 09:24:10'), (12,14,'2026-01-04 09:24:20'),
(13,15,'2026-01-04 09:34:00'), (14,15,'2026-01-04 09:34:10'), (15,15,'2026-01-04 09:34:20'),

(2,16,'2026-01-05 10:04:00'), (3,16,'2026-01-05 10:04:10'), (4,16,'2026-01-05 10:04:20'),
(5,17,'2026-01-05 10:14:00'), (6,17,'2026-01-05 10:14:10'), (7,17,'2026-01-05 10:14:20'),
(8,18,'2026-01-05 10:24:00'), (9,18,'2026-01-05 10:24:10'), (10,18,'2026-01-05 10:24:20'),

(11,19,'2026-01-06 08:04:00'), (12,19,'2026-01-06 08:04:10'), (13,19,'2026-01-06 08:04:20'),
(14,20,'2026-01-06 08:09:00'), (15,20,'2026-01-06 08:09:10'), (16,20,'2026-01-06 08:09:20'),
(17,21,'2026-01-06 08:14:00'), (18,21,'2026-01-06 08:14:10'), (1,21,'2026-01-06 08:14:20'),
(2,22,'2026-01-06 08:16:00'), (3,22,'2026-01-06 08:16:10'), (4,22,'2026-01-06 08:16:20'),
(5,23,'2026-01-06 08:24:00'), (6,23,'2026-01-06 08:24:10'), (7,23,'2026-01-06 08:24:20'),

(8,24,'2026-01-06 08:29:00'), (9,24,'2026-01-06 08:29:10'), (10,24,'2026-01-06 08:29:20'),
(11,25,'2026-01-06 09:04:00'), (12,25,'2026-01-06 09:04:10'), (13,25,'2026-01-06 09:04:20'),
(14,26,'2026-01-06 09:14:00'), (15,26,'2026-01-06 09:14:10'), (16,26,'2026-01-06 09:14:20'),
(17,27,'2026-01-06 09:19:00'), (18,27,'2026-01-06 09:19:10'), (1,27,'2026-01-06 09:19:20'),

(2,28,'2026-01-06 09:24:00'), (3,28,'2026-01-06 09:24:10'), (4,28,'2026-01-06 09:24:20'),
(5,29,'2026-01-07 11:04:00'), (6,29,'2026-01-07 11:04:10'), (7,29,'2026-01-07 11:04:20'),
(8,30,'2026-01-07 11:09:00'), (9,30,'2026-01-07 11:09:10'), (10,30,'2026-01-07 11:09:20');
