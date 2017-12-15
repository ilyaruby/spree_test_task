#/bin/sh

create_user ()
{
  psql -c "create role spree_test_task with login password 'spree_test_task';" -h localhost -p 5432 -U postgres
}

drop_user ()
{
  dropuser -h localhost -U postgres spree_test_task
}

create_database ()
{
  createdb --host=$POSTGRES_PORT_5432_TCP_ADDR \
           --port=$POSTGRES_PORT_5432_TCP_PORT \
           --username=postgres \
           --encoding=UTF8 \
           --locale=ru_RU.UTF8 \
           --template=template0 \
           --owner=$2 \
           $1
  echo "Created database: $1"
}

drop_database ()
{
  dropdb --host=$POSTGRES_PORT_5432_TCP_ADDR \
         --port=$POSTGRES_PORT_5432_TCP_PORT \
         --username=postgres \
         --if-exists \
           $1
  echo "Deleted database: $1"
}

create_all()
{
  create_user
  create_database "spree_test_task_development" "spree_test_task";
  create_database "spree_test_task_test" "spree_test_task";
}

drop_all()
{
  drop_database "spree_test_task_development";
  drop_database "spree_test_task_test";
  drop_user
}

drop_all;
create_all;
