SELECT JSON_ARRAYAGG(
  JSON_OBJECT(
    'id', id,
    'name', name,
    'company', company,
    'lower', lower
  )
) FROM Portal WHERE lower NOT LIKE 'base%' ORDER BY name;
