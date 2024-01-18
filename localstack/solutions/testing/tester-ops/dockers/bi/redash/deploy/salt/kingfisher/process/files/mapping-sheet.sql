SET ROLE reference;

DROP TABLE IF EXISTS reference.mapping_sheets;

CREATE TABLE reference.mapping_sheets (
    id serial primary key,
    version text,
    extension text,
    section text,
    path text,
    title text,
    description text,
    type text,
    range text,
    values text,
    links text,
    deprecated text,
    "deprecationNotes" text
);

\copy reference.mapping_sheets (version, extension, section, path, title, description, type, range, values, links, deprecated, "deprecationNotes") from '{{ path }}' csv header;

SET ROLE NONE;
