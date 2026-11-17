
-- Grupos (Settings → Identity and access → Groups)
-- ingeniero_datos, cientifico_datos, analista_negocio, auditor
GRANT USE CATALOG ON CATALOG workspace TO `ingeniero_datos`, `cientifico_datos`, `analista_negocio`, `auditor`;
GRANT USE SCHEMA, SELECT, MODIFY ON SCHEMA workspace.fraudecero_bronce TO `ingeniero_datos`;
GRANT USE SCHEMA, SELECT, MODIFY ON SCHEMA workspace.fraudecero_plata  TO `ingeniero_datos`;
GRANT USE SCHEMA, SELECT          ON SCHEMA workspace.fraudecero_oro    TO `ingeniero_datos`, `analista_negocio`, `cientifico_datos`;
GRANT USE SCHEMA ON SCHEMA workspace.fraudecero_plata TO `cientifico_datos`, `analista_negocio`;
GRANT SELECT ON TABLE workspace.fraudecero_plata.transacciones_anonimizada TO `cientifico_datos`;
GRANT SELECT ON VIEW  workspace.fraudecero_plata.vw_negocio TO `analista_negocio`;
REVOKE ALL PRIVILEGES ON SCHEMA workspace.fraudecero_bronce FROM `cientifico_datos`, `analista_negocio`;
