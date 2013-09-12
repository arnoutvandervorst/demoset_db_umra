DECLARE @ColID integer = 14

PRINT '# of objects in collection'
SELECT COUNT(*) AS 'Total # of NTFS objects'
FROM GetFilesByCollID(@ColID)

PRINT 'Top-level folders in collection'
SELECT 
dbo.GetFullFilePath(@ColID,f.ID) AS 'NTFS-object'
FROM GetFilesByCollID(@ColID) f
WHERE f.ParentFRN = 0

PRINT 'TOP 25 accounts and groups with the highest number of explicit permissions'
PRINT 'Advice: for security consideration purposes'
SELECT TOP 25
a.Name AS 'Permission-account',
a.Domain AS 'Account-domain',
t.Text AS 'Account-type',
COUNT(ace.ID) AS '# of permissions'
FROM GetFilesByCollID(@ColID) f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
INNER JOIN Acls acl ON acl.ID = sd.DaclID
INNER JOIN AclsVsAces a_a ON a_a.AclID = acl.ID
INNER JOIN Aces ace ON ace.ID = a_a.AceID
INNER JOIN Sids s_ace ON s_ace.ID = ace.SidID
INNER JOIN GetAccountsByCollID(@ColID) a ON a.SidID = s_ace.ID
INNER JOIN AccountTypes t ON t.Type = a.Type
WHERE (a.Type = 1 OR a.Type = 2)
AND NOT ace.Flags & 16 = 16 
GROUP BY a.Name, a.Domain, t.Text
ORDER BY COUNT(ace.ID) DESC

PRINT 'TOP 25 accounts and groups with the highest number of permissions on all objects'
PRINT 'Advice: for security consideration purposes'
SELECT TOP 25
a.Name AS 'Permission-account',
a.Domain AS 'Account-domain',
t.Text AS 'Account-type',
COUNT(ace.ID) AS '# of permissions'
FROM GetFilesByCollID(@ColID) f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
INNER JOIN Acls acl ON acl.ID = sd.DaclID
INNER JOIN AclsVsAces a_a ON a_a.AclID = acl.ID
INNER JOIN Aces ace ON ace.ID = a_a.AceID
INNER JOIN Sids s_ace ON s_ace.ID = ace.SidID
INNER JOIN GetAccountsByCollID(@ColID) a ON a.SidID = s_ace.ID
INNER JOIN AccountTypes t ON t.Type = a.Type
WHERE (a.Type = 1 OR a.Type = 2)
GROUP BY a.Name, a.Domain, t.Text
ORDER BY COUNT(ace.ID) DESC

PRINT 'TOP 25 special explicit permissions on highest number of objects'
PRINT 'Advice: for security consideration purposes, possibly replace with regular rights'
SELECT TOP 25
a.Name AS 'Permission-account',
a.Domain AS 'Account-domain',
t.Text AS 'Account-type',
COUNT(dbo.GetFullFilePath(@ColID,f.ID)) AS '# of permissions'
FROM GetFilesByCollID(@ColID) f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
INNER JOIN Acls acl ON acl.ID = sd.DaclID
INNER JOIN AclsVsAces a_a ON a_a.AclID = acl.ID
INNER JOIN Aces ace ON ace.ID = a_a.AceID
INNER JOIN Sids s_ace ON s_ace.ID = ace.SidID
INNER JOIN GetAccountsByCollID(@ColID) a ON a.SidID = s_ace.ID
INNER JOIN AccountTypes t ON t.Type = a.Type
WHERE NOT ace.Mask IN (SELECT ace_m_v.Value FROM AceMaskValues ace_m_v)
AND NOT ace.Flags & 16 = 16
GROUP BY a.Name, a.Domain, t.Text
ORDER BY COUNT(dbo.GetFullFilePath(@ColID,f.ID)) DESC

PRINT 'Top-level-path explicit permissions for non-admin/wellknown accounts'
PRINT 'Advice: for security consideration purposes, lists permissions without the usual expected admin or default accounts'
SELECT 
dbo.GetFullFilePath(@ColID,f.ID) AS 'NTFS-object',
a.Name AS 'Permission-account',
a.Domain AS 'Account-domain',
t.Text AS 'Account-type',
ISNULL(ace_m_v.Text, 'Special') AS 'Rights'
FROM GetFilesByCollID(@ColID) f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
INNER JOIN Acls acl ON acl.ID = sd.DaclID
INNER JOIN AclsVsAces a_a ON a_a.AclID = acl.ID
INNER JOIN Aces ace ON ace.ID = a_a.AceID
INNER JOIN Sids s_ace ON s_ace.ID = ace.SidID
INNER JOIN GetAccountsByCollID(@ColID) a ON a.SidID = s_ace.ID
INNER JOIN AccountTypes t ON t.Type = a.Type
LEFT JOIN AceMaskValues ace_m_v ON ace_m_v.Value = ace.Mask
WHERE f.ParentFRN = 0
AND NOT (t.Text = 'Alias' 
	OR t.Text = 'WellKnown'
	OR a.Name = 'Administrators'
	OR a.Name = 'Administrator'
	OR a.Name = 'Domain Admins')
AND NOT ace.Flags & 16 = 16

PRINT 'Top-level-path explicit permissions for user accounts'
PRINT 'Advice: usually unwanted, remove these permissions or replace with domain local groups'
SELECT 
dbo.GetFullFilePath(@ColID,f.ID) AS 'NTFS-object',
a.Name AS 'Permission-account',
a.Domain AS 'Account-domain',
ISNULL(ace_m_v.Text, 'Special') AS 'Rights'
FROM GetFilesByCollID(@ColID) f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
INNER JOIN Acls acl ON acl.ID = sd.DaclID
INNER JOIN AclsVsAces a_a ON a_a.AclID = acl.ID
INNER JOIN Aces ace ON ace.ID = a_a.AceID
INNER JOIN Sids s_ace ON s_ace.ID = ace.SidID
INNER JOIN GetAccountsByCollID(@ColID) a ON a.SidID = s_ace.ID
LEFT JOIN AceMaskValues ace_m_v ON ace_m_v.Value = ace.Mask
WHERE a.Type = 1
AND f.ParentFRN = 0
AND NOT ace.Flags & 16 = 16

PRINT 'Explicit permissions for user accounts on all objects'
PRINT 'Advice: usually unwanted, remove these permissions or replace with domain local groups'
SELECT 
dbo.GetFullFilePath(@ColID,f.ID) AS 'NTFS-object',
a.Name AS 'Permission-account',
a.Domain AS 'Account-domain',
ISNULL(ace_m_v.Text, 'Special') AS 'Rights'
FROM GetFilesByCollID(@ColID) f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
INNER JOIN Acls acl ON acl.ID = sd.DaclID
INNER JOIN AclsVsAces a_a ON a_a.AclID = acl.ID
INNER JOIN Aces ace ON ace.ID = a_a.AceID
INNER JOIN Sids s_ace ON s_ace.ID = ace.SidID
INNER JOIN GetAccountsByCollID(@ColID) a ON a.SidID = s_ace.ID
LEFT JOIN AceMaskValues ace_m_v ON ace_m_v.Value = ace.Mask
WHERE a.Type = 1
AND NOT ace.Flags & 16 = 16

PRINT 'Top-level-path explicit permissions for global groups'
PRINT 'Advice: usually unwanted, remove these permissions or replace with domain local groups'
SELECT 
dbo.GetFullFilePath(@ColID,f.ID) AS 'NTFS-object',
a.Name AS 'Permission-account',
a.Domain AS 'Account-domain',
t.Text AS 'Account-type',
ISNULL(ace_m_v.Text, 'Special') AS 'Rights'
FROM GetFilesByCollID(@ColID) f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
INNER JOIN Acls acl ON acl.ID = sd.DaclID
INNER JOIN AclsVsAces a_a ON a_a.AclID = acl.ID
INNER JOIN Aces ace ON ace.ID = a_a.AceID
INNER JOIN Sids s_ace ON s_ace.ID = ace.SidID
INNER JOIN GetAccountsByCollID(@ColID) a ON a.SidID = s_ace.ID
INNER JOIN AccountTypes t ON t.Type = a.Type
LEFT JOIN AceMaskValues ace_m_v ON ace_m_v.Value = ace.Mask
WHERE a.GroupType = '-2147483646'
AND f.ParentFRN = 0
AND NOT ace.Flags & 16 = 16

PRINT 'Explicit permissions for global groups on all objects'
PRINT 'Advice: usually unwanted, remove these permissions or replace with domain local groups'
SELECT
dbo.GetFullFilePath(@ColID,f.ID) AS 'NTFS-object',
a.Name AS 'Permission-account',
a.Domain AS 'Account-domain',
t.Text AS 'Account-type',
ISNULL(ace_m_v.Text, 'Special') AS 'Rights'
FROM GetFilesByCollID(@ColID) f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
INNER JOIN Acls acl ON acl.ID = sd.DaclID
INNER JOIN AclsVsAces a_a ON a_a.AclID = acl.ID
INNER JOIN Aces ace ON ace.ID = a_a.AceID
INNER JOIN Sids s_ace ON s_ace.ID = ace.SidID
INNER JOIN GetAccountsByCollID(@ColID) a ON a.SidID = s_ace.ID
INNER JOIN AccountTypes t ON t.Type = a.Type
LEFT JOIN AceMaskValues ace_m_v ON ace_m_v.Value = ace.Mask
WHERE a.GroupType = '-2147483646'
AND NOT ace.Flags & 16 = 16

PRINT 'Explicit "Full Control" permissions for user accounts on all objects'
PRINT 'Advice: for security consideration purposes'
SELECT 
dbo.GetFullFilePath(@ColID,f.ID) AS 'NTFS-object',
a.Name AS 'Permission-account',
a.Domain AS 'Account-domain'
FROM GetFilesByCollID(@ColID) f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
INNER JOIN Acls acl ON acl.ID = sd.DaclID
INNER JOIN AclsVsAces a_a ON a_a.AclID = acl.ID
INNER JOIN Aces ace ON ace.ID = a_a.AceID
INNER JOIN Sids s_ace ON s_ace.ID = ace.SidID
INNER JOIN GetAccountsByCollID(@ColID) a ON a.SidID = s_ace.ID
WHERE a.Type = 1
AND (ace.Mask = 2032127 OR ace.Mask = 268435456)
AND NOT ace.Flags & 16 = 16

PRINT 'Explicit "Change/Modify" permissions for user accounts on all objects'
PRINT 'Advice: for security consideration purposes'
SELECT 
dbo.GetFullFilePath(@ColID,f.ID) AS 'NTFS-object',
a.Name AS 'Permission-account',
a.Domain AS 'Account-domain'
FROM GetFilesByCollID(@ColID) f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
INNER JOIN Acls acl ON acl.ID = sd.DaclID
INNER JOIN AclsVsAces a_a ON a_a.AclID = acl.ID
INNER JOIN Aces ace ON ace.ID = a_a.AceID
INNER JOIN Sids s_ace ON s_ace.ID = ace.SidID
INNER JOIN GetAccountsByCollID(@ColID) a ON a.SidID = s_ace.ID
WHERE a.Type = 1
AND ace.Mask = 1245631
AND NOT ace.Flags & 16 = 16

PRINT 'All explicit "deny" permissions'
PRINT 'Advice: for security consideration purposes, should be kept to a minimum'
SELECT 
dbo.GetFullFilePath(@ColID,f.ID) AS 'NTFS-object',
a.Name AS 'Permission-account',
a.Domain AS 'Account-domain',
t.Text AS 'Account-type',
ISNULL(ace_m_v.Text, 'Special') AS 'Rights'
FROM GetFilesByCollID(@ColID) f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
INNER JOIN Acls acl ON acl.ID = sd.DaclID
INNER JOIN AclsVsAces a_a ON a_a.AclID = acl.ID
INNER JOIN Aces ace ON ace.ID = a_a.AceID
INNER JOIN Sids s_ace ON s_ace.ID = ace.SidID
INNER JOIN GetAccountsByCollID(@ColID) a ON a.SidID = s_ace.ID
INNER JOIN AccountTypes t ON t.Type = a.Type
LEFT JOIN AceMaskValues ace_m_v ON ace_m_v.Value = ace.Mask
WHERE (ace.Type = 1 OR ace.Type = 6 OR ace.Type = 10 OR ace.Type = 12)
AND NOT ace.Flags & 16 = 16

PRINT 'All explicit "special" permissions, AS listed by Windows Explorer AS "special"'
PRINT 'Advice: for security consideration purposes, should be kept to a minimum'
SELECT 
dbo.GetFullFilePath(@ColID,f.ID) AS 'NTFS-object',
a.Name AS 'Permission-account',
a.Domain AS 'Account-domain',
t.Text AS 'Account-type',
(SELECT CASE WHEN ace.Mask & 1 = 1 THEN 'Yes' ELSE 'No' END) AS 'List Folder/Read Data',
(SELECT CASE WHEN ace.Mask & 2 = 2 THEN 'Yes' ELSE 'No' END) AS 'Create Files/Write Data',
(SELECT CASE WHEN ace.Mask & 4 = 4 THEN 'Yes' ELSE 'No' END) AS 'Create Folders/Append Data',
(SELECT CASE WHEN ace.Mask & 8 = 8 THEN 'Yes' ELSE 'No' END) AS 'Read Extended Attributes',
(SELECT CASE WHEN ace.Mask & 16 = 16 THEN 'Yes' ELSE 'No' END) AS 'Write Extended Attributes',
(SELECT CASE WHEN ace.Mask & 32 = 32 THEN 'Yes' ELSE 'No' END) AS 'Traverse Folder/Execute File',
(SELECT CASE WHEN ace.Mask & 64 = 64 THEN 'Yes' ELSE 'No' END) AS 'Delete Subdirectories/Files',
(SELECT CASE WHEN ace.Mask & 128 = 128 THEN 'Yes' ELSE 'No' END) AS 'Read Attributes',
(SELECT CASE WHEN ace.Mask & 256 = 256 THEN 'Yes' ELSE 'No' END) AS 'Write Attributes',
(SELECT CASE WHEN ace.Mask & 278 = 278 THEN 'Yes' ELSE 'No' END) AS 'Write',
(SELECT CASE WHEN ace.Mask & 65536 = 65536 THEN 'Yes' ELSE 'No' END) AS 'Delete',
(SELECT CASE WHEN ace.Mask & 131209 = 131209 THEN 'Yes' ELSE 'No' END) AS 'Read',
(SELECT CASE WHEN ace.Mask & 131072 = 131072 THEN 'Yes' ELSE 'No' END) AS 'Read Permissions',
(SELECT CASE WHEN ace.Mask & 262144 = 262144 THEN 'Yes' ELSE 'No' END) AS 'Change Permissions',
(SELECT CASE WHEN ace.Mask & 524288 = 524288 THEN 'Yes' ELSE 'No' END) AS 'Take Ownership'
FROM GetFilesByCollID(@ColID) f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
INNER JOIN Acls acl ON acl.ID = sd.DaclID
INNER JOIN AclsVsAces a_a ON a_a.AclID = acl.ID
INNER JOIN Aces ace ON ace.ID = a_a.AceID
INNER JOIN Sids s_ace ON s_ace.ID = ace.SidID
INNER JOIN GetAccountsByCollID(@ColID) a ON a.SidID = s_ace.ID
INNER JOIN AccountTypes t ON t.Type = a.Type
WHERE NOT ace.Mask IN (SELECT ace_m_v.Value FROM AceMaskValues ace_m_v)
AND NOT ace.Flags & 16 = 16

PRINT 'NTFS-objects with SIDs that no longer represent an Active Directory user account or group, or a local computer account'
PRINT 'Advice: should be removed since they are no longer valid permissions, improves NTFS performance'
SELECT
dbo.GetFullFilePath(@ColID,f.ID) AS 'NTFS-object',
s_ace.String AS 'SID',
ISNULL(ace_m_v.Text, 'Special') AS 'Rights'
FROM GetFilesByCollID(@ColID) f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
INNER JOIN Acls acl ON acl.ID = sd.DaclID
INNER JOIN AclsVsAces a_a ON a_a.AclID = acl.ID
INNER JOIN Aces ace ON ace.ID = a_a.AceID
INNER JOIN Sids s_ace ON s_ace.ID = ace.SidID
LEFT JOIN GetAccountsByCollID(@ColID) a ON a.SidID = s_ace.ID
LEFT JOIN AceMaskValues ace_m_v ON ace_m_v.Value = ace.Mask
WHERE a.Name IS NULL
AND NOT ace.Flags & 16 = 16

PRINT 'All explicit permissions where the propagation to sub-objects (CI/OI) has been modified, default = "This folder, subfolders, and files"'
PRINT 'Advice: for careful consideration, disabling propagation causes possible unwanted behavior and reduces readability of permissions'
SELECT 
dbo.GetFullFilePath(@ColID,f.ID) AS 'NTFS-object',
a.Name AS 'Permission-account',
a.Domain AS 'Account-domain',
t.Text AS 'Account-type',
ISNULL(ace_m_v.Text, 'Special') AS 'Rights'
FROM GetFilesByCollID(@ColID) f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
INNER JOIN Acls acl ON acl.ID = sd.DaclID
INNER JOIN AclsVsAces a_a ON a_a.AclID = acl.ID
INNER JOIN Aces ace ON ace.ID = a_a.AceID
INNER JOIN Sids s_ace ON s_ace.ID = ace.SidID
INNER JOIN GetAccountsByCollID(@ColID) a ON a.SidID = s_ace.ID
INNER JOIN AccountTypes t ON t.Type = a.Type
LEFT JOIN AceMaskValues ace_m_v ON ace_m_v.Value = ace.Mask
WHERE NOT (ace.Flags & 1 = 1 AND ace.Flags & 2 = 2)
AND NOT ace.Flags & 16 = 16

PRINT 'All NTFS objects which are protected from the effects of inherited rights'
PRINT 'Advice: for careful consideration, disabling inheritance causes possible unwanted behavior and reduces readability of permissions'
SELECT 
dbo.GetFullFilePath(@ColID,f.ID) AS 'NTFS-object'
FROM GetFilesByCollID(@ColID) f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
WHERE (sd.SdControl & 4096 = 4096 OR sd.SdControl & 8192 = 8192)