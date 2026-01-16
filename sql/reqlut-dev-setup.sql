-- Reqlut Development Setup Script
-- Configura permisos de admin y limpia datos de usuarios de prueba
-- @authId se define externamente via Makefile

-- Asignar todos los roles al usuario
INSERT INTO AuthRole (auth_id, role_id)
SELECT @authId, id FROM Role
WHERE id NOT IN (SELECT role_id FROM AuthRole WHERE auth_id = @authId);

-- Asignar acceso a todos los portales genéricos
INSERT INTO AlumniAuth (auth_id, portal_id, active, createdAt, updatedAt)
SELECT @authId, p.id, 1, NOW(), NOW()
FROM Portal p
    INNER JOIN Alumni a ON p.alumni_id = a.id AND a.isGeneric = 1
WHERE p.id NOT IN (SELECT portal_id FROM AlumniAuth WHERE auth_id = @authId);

-- Asignar admin de portales de empleo
INSERT INTO AlumniAdmin (portal_id, auth_id, isAlumniAdmin, isJobOffersAdmin, active, studentsAdmin, showRut, createdAt, updatedAt)
SELECT id, @authId, 1, 1, 1, 1, 1, NOW(), NOW()
FROM Portal
WHERE isJobPortal = 1 AND id NOT IN (SELECT portal_id FROM AlumniAuth WHERE auth_id = @authId);

-- Asignar admin de expos
INSERT INTO ExpoAdmin (expo_id, auth_id)
SELECT id, @authId FROM Expo
WHERE id NOT IN (SELECT expo_id FROM ExpoAdmin WHERE auth_id = @authId);

-- Eliminar triggers de cache
DROP TRIGGER IF EXISTS dbCachePortalTrigger;
DROP TRIGGER IF EXISTS dbCacheCountryTrigger;
DROP TRIGGER IF EXISTS dbCacheIdentificationTypeTrigger;
DROP TRIGGER IF EXISTS dbCacheIdentificationTypeGroupTrigger;
DROP TRIGGER IF EXISTS dbCachePortalJobOfferTypeTrigger;
DROP TRIGGER IF EXISTS dbCacheJobOfferTypeTrigger;
DROP TRIGGER IF EXISTS dbCacheAlumniFacultyTrigger;
DROP TRIGGER IF EXISTS dbCachePortalMainPortalTrigger;
DROP TRIGGER IF EXISTS dbCacheAlumniNewTypeTrigger;
DROP TRIGGER IF EXISTS dbCacheNetworkingTypeTrigger;
DROP TRIGGER IF EXISTS dbCacheApiTrigger;
DROP TRIGGER IF EXISTS dbCacheAlumniPlacementTypeTrigger;
DROP TRIGGER IF EXISTS dbCachePortalConfigProfileTrigger;
DROP TRIGGER IF EXISTS dbCacheAlumniInternshipTypeTrigger;
DROP TRIGGER IF EXISTS dbCacheAlumniFrequentQuestionsGroupTrigger;
DROP TRIGGER IF EXISTS dbCacheInsertAlumniFrequentQuestionsGroupTrigger;

-- Obtener el máximo ID de Auth para limpieza
SET @maxAuthId = (SELECT MAX(id) FROM Auth);

-- Configurar portales para desarrollo local
UPDATE Portal SET domain = CONCAT("reqlut-", id, ".nicodev.work"), secondaryDomain = NULL, protocol = 'https://', stage = 1;
UPDATE Portal SET hasMercadoPago = 1, MP_AccessToken = 'TEST-6513925161036011-051513-69a1ec9a3dce6c2fb599e2eeca72c2d5-656280762', MP_PublicKey = 'TEST-84188492-b5d2-40f4-a3fb-cbf149e4a282' WHERE id = 1 LIMIT 1;

-- Limpiar datos de usuarios de prueba (id > maxAuthId)
DELETE FROM UserConfig WHERE id > @maxAuthId;
DELETE FROM UserCareer WHERE user_id > @maxAuthId;
DELETE FROM UserJob WHERE user_id > @maxAuthId;
DELETE FROM UserLanguage WHERE user_id > @maxAuthId;
DELETE FROM UserSchool WHERE user_id > @maxAuthId;
DELETE FROM UserHability WHERE user_id > @maxAuthId;
DELETE FROM UserAdditionalInfo WHERE user_id > @maxAuthId;
DELETE FROM UserMayerBriggs WHERE id > @maxAuthId;
DELETE FROM UserJobOfferType WHERE user_id > @maxAuthId;
DELETE FROM UserPostgraduate WHERE user_id > @maxAuthId;

-- Limpiar ofertas de trabajo de usuarios de prueba
DELETE FROM JobOfferGenericCareer WHERE jobOffer_id IN (SELECT id FROM JobOffer WHERE creator_id > @maxAuthId);
DELETE FROM JobOfferBenefit WHERE jobOffer_id IN (SELECT id FROM JobOffer WHERE creator_id > @maxAuthId);
DELETE FROM JobOfferHability WHERE jobOffer_id IN (SELECT id FROM JobOffer WHERE creator_id > @maxAuthId);
DELETE FROM JobOfferLanguage WHERE jobOffer_id IN (SELECT id FROM JobOffer WHERE creator_id > @maxAuthId);
DELETE FROM JobOfferQuestionChoice WHERE question_id IN (SELECT id FROM JobOfferQuestion WHERE jobOffer_id IN (SELECT id FROM JobOffer WHERE creator_id > @maxAuthId));
DELETE FROM JobOfferQuestion WHERE jobOffer_id IN (SELECT id FROM JobOffer WHERE creator_id > @maxAuthId);
DELETE FROM JobOfferAdditionalInfoAnswer WHERE jobOffer_id IN (SELECT id FROM JobOffer WHERE creator_id > @maxAuthId);
DELETE FROM Invitation WHERE jobOffer_id IN (SELECT id FROM JobOffer WHERE creator_id > @maxAuthId);
UPDATE JobOffer SET mainJobOffer_id = null WHERE creator_id > @maxAuthId;
DELETE FROM JobOffer WHERE creator_id > @maxAuthId;

-- Limpiar datos adicionales de usuarios de prueba
DELETE FROM CompanyUser WHERE user_id > @maxAuthId;
DELETE FROM UserConfig WHERE id > @maxAuthId;
DELETE FROM UserDisability WHERE user_id > @maxAuthId;
DELETE FROM UserFormAnswer WHERE user_id > @maxAuthId;
DELETE FROM ExpoUserBlockedSlot WHERE user_id > @maxAuthId;
DELETE FROM UserNetworkingTopic WHERE user_id IN (SELECT id FROM UserPortalConfig WHERE user_id > @maxAuthId);
DELETE FROM UserPortalConfig WHERE user_id > @maxAuthId;
DELETE FROM UsersAdditionalInfoAnswer WHERE user_id > @maxAuthId;
DELETE FROM UserExternalPortalJob WHERE user_id > @maxAuthId;
DELETE FROM PublicationMovement WHERE user_id > @maxAuthId;
DELETE FROM Transaction WHERE user_id > @maxAuthId;
DELETE FROM OpenAIUsage WHERE user_id > @maxAuthId;
DELETE FROM ProfileView WHERE user_id > @maxAuthId;
DELETE FROM ProfileOpen WHERE user_id > @maxAuthId;
DELETE FROM Application WHERE user_id > @maxAuthId;
DELETE FROM ExpoApplication WHERE user_id > @maxAuthId;
DELETE FROM InterviewSimulatorAnswer WHERE user_id > @maxAuthId;
DELETE FROM UserPlacement WHERE user_id > @maxAuthId;
DELETE FROM PortalUserApp WHERE user_id > @maxAuthId;
DELETE FROM MicroCompanyUser WHERE user_id > @maxAuthId;

-- Limpiar alertas de trabajo
DELETE FROM UserJobAlertTownship WHERE jobAlert_id IN (SELECT id FROM UserJobAlert WHERE user_id > @maxAuthId);
DELETE FROM UserJobAlertGenericCareer WHERE jobAlert_id IN (SELECT id FROM UserJobAlert WHERE user_id > @maxAuthId);
DELETE FROM UserJobAlert WHERE user_id > @maxAuthId;

-- Limpiar procesos de blog
DELETE FROM ProcessBlogApproval WHERE (SELECT id FROM ProcessBlog WHERE request_id IN (SELECT id FROM ProcessRequest WHERE user_id > @maxAuthId));
DELETE FROM ProcessBlog WHERE request_id IN (SELECT id FROM ProcessRequest WHERE user_id > @maxAuthId);
DELETE FROM ProcessRequest WHERE user_id > @maxAuthId;

-- Limpiar usuarios externos
DELETE FROM ExternalUser WHERE user_id > @maxAuthId;

-- Eliminar usuarios de prueba
DELETE FROM User WHERE id > @maxAuthId;
