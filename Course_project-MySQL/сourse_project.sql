drop database if exists contract_supervision;
create database contract_supervision;

use contract_supervision;

-- далее по тексту в комментах ШМУ - шеф-монтажные услуги

-- информация о проекте
drop table if exists projects; 
create table projects(
	id serial primary key, 
	project_number char(20),
	customer varchar(50) comment 'наименование заказчика',
	city_of_project varchar(50),
	started_at date,
    completed_at date
);

-- информация о персонале компании, задействованной на проекте в качестве организации, оказывающей ШМУ.

drop table if exists personnel; 
create table personnel(
	id serial primary key, 
    project_id bigint unsigned not null,
	name varchar(50),
	surname varchar(50),
	phone varchar(20) unique,
	birthday date,
	job_position varchar(255),
	foreign key (project_id) references projects(id)
);

-- информация о компании, выполняющей монтаж.
drop table if exists erection_company;
create table erection_company(
	erection_company_id serial primary key,
	project_id bigint unsigned not null,
	company_name varchar(50),
	workers_quantity bigint,
	engineers_quantity bigint,
	foreign key (erection_company_id) references projects(id)
);

-- оборудование, необходимое персоналу для выполнения ШМУ
drop table if exists equipment;
create table equipment(
	equipment_id serial primary key,
    employer_id bigint unsigned not null,
	name varchar(150),
	index(name),
    serial_number bigint unsigned not null,
    calibration_date_before date, -- срок поверки прибора до...
    foreign key (employer_id) references personnel(id)
);

-- информация об аттестации персонала, оказывающего ШМУ
drop table if exists qualification_record;
create table qualification_record (
	id serial primary key,
    employer_id bigint unsigned not null,
	description varchar(150),
	license_number char(50),
    license_date_before date, -- срок действия квалификационного удостоверения
	foreign key (employer_id) references personnel(id)
);

-- информация о месте проживания в командировке
drop table if exists residence_data;
create table residence_data(
	id serial primary key,
	employer_id bigint unsigned not null,
    project_id bigint unsigned not null,
	hotel_name varchar(150),
	city_of_residence varchar(50),
    foreign key (project_id) references projects(id),
	foreign key (employer_id) references personnel(id)
);


-- информация по расходованию средств в командировках персоналом, выполняющим ШМУ
drop table if exists expenditure;
create table expenditure(
	id serial primary key,
	employer_id bigint unsigned not null,
    project_id bigint unsigned not null,
	food DECIMAL (11,2) comment 'Затраты на питание',
	journey_costs DECIMAL (11,2) comment 'Затраты на проезд',
    habitation_costs DECIMAL (11,2) comment 'Затраты на проживание',
 	foreign key (employer_id) references personnel(id),
    foreign key (project_id) references projects(id)
);

-- отзывы заказчика по факту оказания ШМУ 
drop table if exists customer_feedback;
create table customer_feedback(
	id serial primary key,
    project_id bigint unsigned not null,
	quality ENUM('excellent', 'satisfactory', 'might be better') comment 'Качество работ',
	relationship ENUM('excellent', 'satisfactory', 'might be better') comment 'Взаимоотношения',
	observance_of_a_treaty ENUM('excellent', 'satisfactory', 'might be better') comment 'Соблюдение договора',
	foreign key (project_id) references projects(id)
);

-- отзывы персонала, задействованного в реализации ШМУ

drop table if exists personnel_feedback;
create table personnel_feedback(
	id serial primary key,
    project_id bigint unsigned not null,
    employer_id bigint unsigned not null,
	quality ENUM('excellent', 'satisfactory', 'might be better') comment 'Качество работ',
	relationship_with_erection_team ENUM('excellent', 'satisfactory', 'might be better') comment 'Взаимоотношения с монтажной организацией',
	conditions_at_work ENUM('excellent', 'satisfactory', 'might be better') comment 'Условия труда на монтажной площадке',
	foreign key (project_id) references projects(id),
    foreign key (employer_id) references personnel(id)
);

-- информация о проблемах, с которыми столкнулся персонал, оказывающий ШМУ, при реализации проекта
 
drop table if exists project_summary;
create table project_summary(
	id serial primary key,
    project_id bigint unsigned not null,
    employer_id bigint unsigned not null,
	description_of_problem text comment 'Описание проблемы',
	foreign key (project_id) references projects(id),
    foreign key (employer_id) references personnel(id)
);

