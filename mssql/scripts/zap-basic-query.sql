-- Makes a script that drops all basic objects
with Objects as (select type,
                        name collate Latin1_General_bin as name,
                        create_date
                 from sys.objects
                 where schema_id = schema_id('Zoo')
                   and name like 'Basic_%'
                 union all
                 select '+Y' as type,
                        name collate Latin1_General_bin as name,
                        create_date
                 from sys.synonyms
                 where schema_id = schema_id('Zoo')
                   and name like 'Basic_%'
                 ),
     Types as (select *
               from (values ('SO', 'sequence'),
                            ('U',  'table'),
                            ('V',  'view'),
                            ('FN', 'function'),
                            ('P',  'procedure'),
                            ('+Y', 'synonym')
                     ) as the_types(type, word)),
     Regular_Objects as (select concat('drop ', word, ' Zoo.', name) as Command,
                                1 as priority,
                                create_date,
                                name
                         from Objects join Types
                                      on Objects.type = Types.type),
     Custom_Types as (select concat('drop type Zoo.', name collate Latin1_General_bin) as Command,
                             3 - is_table_type as priority,
                             cast(null as datetime) as create_date,
                             name
                      from sys.types
                      where schema_id = schema_id('Zoo')
                        and name like 'Basic_%'),
     Objects_to_Drop as (select *
                         from Regular_Objects
                         union all
                         select *
                         from Custom_Types)
select Command
from Objects_to_Drop
order by priority, create_date desc, name desc
go