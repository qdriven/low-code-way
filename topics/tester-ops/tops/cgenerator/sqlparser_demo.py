# encoding: utf-8
## pip install sqlparse
import re

# import sqlparse


# print(type(content))
# print(content)
#
# sql = sqlparse.parse(content)
# print(sql)
# print(sql[0].tokens)
#
# for token in sql[0].tokens:
#     print(type(token),token.ttype,token.value)

sql_java_type_mapping = {
    "bigint": "Long",
    "varchar": "String",
    "int": "Integer",
    "timestamp": "DateTime",
    "datetime": "Date"
}

type_re = r"(\(\d+\))"


def parse_create_sql(create_sql_file="sql_create.sql"):
    with open(create_sql_file, 'r', encoding='utf-8') as sql_file:
        lines = sql_file.readlines()
    columns = []
    for line in lines:
        if not line.strip().upper().startswith("CREATE") and line.upper().strip().startswith("`"):
            parsed = line.strip().split(" ")
            result = (parsed[0].replace("`", ""), re.sub(type_re, "", parsed[1]))
            print(result)
            columns.append(result)
    return columns


java_declare_template = "private {type} {name};"


def make_java_field_name(col_name):
    parsed_col_name = col_name.split("_")
    if len(parsed_col_name) > 1:
        return "".join([parsed_col_name[0].lower(), parsed_col_name[1].lower().capitalize()])
    else:
        return col_name.lower()


def print_java_entity(create_sql_file="sql_create.sql"):
    columns = parse_create_sql(create_sql_file)
    for column in columns:
        field_name = column[0]
        sql_type = column[1]
        java_type = sql_java_type_mapping.get(sql_type.lower(), "String")
        print(java_declare_template.format(type=java_type, name=make_java_field_name(field_name)))


print_java_entity()
