DECLARE @ColID integer = 1 --specify the Collection ID which should be used for query execution

PRINT '# of objects in collection'
SELECT COUNT(*) AS 'Total # of NTFS objects'
FROM GetFilesByCollID(@ColID)

PRINT 'Top-level folders in collection'
SELECT 
REPLACE(dbo.GetFullFilePath(@ColID,f.ID),'\\?\UNC\','\\') AS 'NTFS-object'
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
INNER JOIN Accounts a ON a.SidID = s_ace.ID
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
INNER JOIN Accounts a ON a.SidID = s_ace.ID
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
INNER JOIN Accounts a ON a.SidID = s_ace.ID
INNER JOIN AccountTypes t ON t.Type = a.Type
WHERE NOT ace.Mask IN (SELECT ace_m_v.Value FROM AceMaskValues ace_m_v)
AND NOT ace.Flags & 16 = 16
AND NOT t.Text = 'WellKnown'
GROUP BY a.Name, a.Domain, t.Text
ORDER BY COUNT(dbo.GetFullFilePath(@ColID,f.ID)) DESC

PRINT 'Top-level-path explicit permissions for non-admin/wellknown accounts'
PRINT 'Advice: for security consideration purposes, lists permissions without the usual expected admin or default accounts'
SELECT 
REPLACE(dbo.GetFullFilePath(@ColID,f.ID),'\\?\UNC\','\\') AS 'NTFS-object',
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
INNER JOIN Accounts a ON a.SidID = s_ace.ID
INNER JOIN AccountTypes t ON t.Type = a.Type
LEFT JOIN AceMaskValues ace_m_v ON ace_m_v.Value = ace.Mask
WHERE f.ParentFRN = 0
AND NOT (t.Text = 'Alias' 
	OR t.Text = 'WellKnown'
	OR a.Name = 'Administrators'
	OR a.Name = 'Administrator'
	OR a.Name = 'Domain Admins'
	OR a.Name = 'Domain Users')
AND NOT ace.Flags & 16 = 16

PRINT 'Top-level-path explicit permissions for user accounts'
PRINT 'Advice: usually unwanted, remove these permissions or replace with domain local groups'
SELECT 
REPLACE(dbo.GetFullFilePath(@ColID,f.ID),'\\?\UNC\','\\') AS 'NTFS-object',
a.Name AS 'Permission-account',
a.Domain AS 'Account-domain',
ISNULL(ace_m_v.Text, 'Special') AS 'Rights'
FROM GetFilesByCollID(@ColID) f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
INNER JOIN Acls acl ON acl.ID = sd.DaclID
INNER JOIN AclsVsAces a_a ON a_a.AclID = acl.ID
INNER JOIN Aces ace ON ace.ID = a_a.AceID
INNER JOIN Sids s_ace ON s_ace.ID = ace.SidID
INNER JOIN Accounts a ON a.SidID = s_ace.ID
INNER JOIN AccountTypes t ON t.Type = a.Type
LEFT JOIN AceMaskValues ace_m_v ON ace_m_v.Value = ace.Mask
WHERE a.Type = 1
AND f.ParentFRN = 0
AND NOT t.Text = 'WellKnown'
AND NOT ace.Flags & 16 = 16

PRINT 'Explicit permissions for user accounts on all objects'
PRINT 'Advice: usually unwanted, remove these permissions or replace with domain local groups'
SELECT 
REPLACE(dbo.GetFullFilePath(@ColID,f.ID),'\\?\UNC\','\\') AS 'NTFS-object',
a.Name AS 'Permission-account',
a.Domain AS 'Account-domain',
ISNULL(ace_m_v.Text, 'Special') AS 'Rights'
FROM GetFilesByCollID(@ColID) f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
INNER JOIN Acls acl ON acl.ID = sd.DaclID
INNER JOIN AclsVsAces a_a ON a_a.AclID = acl.ID
INNER JOIN Aces ace ON ace.ID = a_a.AceID
INNER JOIN Sids s_ace ON s_ace.ID = ace.SidID
INNER JOIN Accounts a ON a.SidID = s_ace.ID
LEFT JOIN AceMaskValues ace_m_v ON ace_m_v.Value = ace.Mask
WHERE a.Type = 1
AND NOT ace.Flags & 16 = 16

PRINT 'Top-level-path explicit permissions for global groups'
PRINT 'Advice: usually unwanted, remove these permissions or replace with domain local groups'
SELECT 
REPLACE(dbo.GetFullFilePath(@ColID,f.ID),'\\?\UNC\','\\') AS 'NTFS-object',
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
INNER JOIN Accounts a ON a.SidID = s_ace.ID
INNER JOIN AccountTypes t ON t.Type = a.Type
LEFT JOIN AceMaskValues ace_m_v ON ace_m_v.Value = ace.Mask
WHERE a.GroupType = '-2147483646'
AND f.ParentFRN = 0
AND NOT ace.Flags & 16 = 16
AND NOT (a.Name = 'Domain Admins' OR a.Name = 'Domain Users')

PRINT 'Explicit permissions for global groups on all objects'
PRINT 'Advice: usually unwanted, remove these permissions or replace with domain local groups'
SELECT
REPLACE(dbo.GetFullFilePath(@ColID,f.ID),'\\?\UNC\','\\') AS 'NTFS-object',
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
INNER JOIN Accounts a ON a.SidID = s_ace.ID
INNER JOIN AccountTypes t ON t.Type = a.Type
LEFT JOIN AceMaskValues ace_m_v ON ace_m_v.Value = ace.Mask
WHERE a.GroupType = '-2147483646'
AND NOT ace.Flags & 16 = 16
AND NOT (a.Name = 'Domain Admins' OR a.Name = 'Domain Users')

PRINT 'Top-level-path explicit permissions for domain local groups'
PRINT 'Advice: for security consideration purposes, domain local groups should be used for NTFS permissions'
SELECT 
REPLACE(dbo.GetFullFilePath(@ColID,f.ID),'\\?\UNC\','\\') AS 'NTFS-object',
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
INNER JOIN Accounts a ON a.SidID = s_ace.ID
INNER JOIN AccountTypes t ON t.Type = a.Type
LEFT JOIN AceMaskValues ace_m_v ON ace_m_v.Value = ace.Mask
WHERE a.GroupType = '-2147483644'
AND f.ParentFRN = 0
AND NOT ace.Flags & 16 = 16

PRINT 'Explicit permissions for domain local groups on all objects'
PRINT 'Advice: for security consideration purposes, domain local groups should be used for NTFS permissions'
SELECT
REPLACE(dbo.GetFullFilePath(@ColID,f.ID),'\\?\UNC\','\\') AS 'NTFS-object',
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
INNER JOIN Accounts a ON a.SidID = s_ace.ID
INNER JOIN AccountTypes t ON t.Type = a.Type
LEFT JOIN AceMaskValues ace_m_v ON ace_m_v.Value = ace.Mask
WHERE a.GroupType = '-2147483644'
AND NOT ace.Flags & 16 = 16

PRINT 'Explicit "Full Control" permissions for user accounts on all objects'
PRINT 'Advice: for security consideration purposes'
SELECT 
REPLACE(dbo.GetFullFilePath(@ColID,f.ID),'\\?\UNC\','\\') AS 'NTFS-object',
a.Name AS 'Permission-account',
a.Domain AS 'Account-domain'
FROM GetFilesByCollID(@ColID) f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
INNER JOIN Acls acl ON acl.ID = sd.DaclID
INNER JOIN AclsVsAces a_a ON a_a.AclID = acl.ID
INNER JOIN Aces ace ON ace.ID = a_a.AceID
INNER JOIN Sids s_ace ON s_ace.ID = ace.SidID
INNER JOIN Accounts a ON a.SidID = s_ace.ID
WHERE a.Type = 1
AND (ace.Mask = 2032127 OR ace.Mask = 268435456)
AND NOT ace.Flags & 16 = 16

PRINT 'Explicit "Change/Modify" permissions for user accounts on all objects'
PRINT 'Advice: for security consideration purposes'
SELECT 
REPLACE(dbo.GetFullFilePath(@ColID,f.ID),'\\?\UNC\','\\') AS 'NTFS-object',
a.Name AS 'Permission-account',
a.Domain AS 'Account-domain'
FROM GetFilesByCollID(@ColID) f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
INNER JOIN Acls acl ON acl.ID = sd.DaclID
INNER JOIN AclsVsAces a_a ON a_a.AclID = acl.ID
INNER JOIN Aces ace ON ace.ID = a_a.AceID
INNER JOIN Sids s_ace ON s_ace.ID = ace.SidID
INNER JOIN Accounts a ON a.SidID = s_ace.ID
WHERE a.Type = 1
AND ace.Mask = 1245631
AND NOT ace.Flags & 16 = 16

PRINT 'All explicit "deny" permissions'
PRINT 'Advice: for security consideration purposes, should be kept to a minimum'
SELECT 
REPLACE(dbo.GetFullFilePath(@ColID,f.ID),'\\?\UNC\','\\') AS 'NTFS-object',
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
INNER JOIN Accounts a ON a.SidID = s_ace.ID
INNER JOIN AccountTypes t ON t.Type = a.Type
LEFT JOIN AceMaskValues ace_m_v ON ace_m_v.Value = ace.Mask
WHERE (ace.Type = 1 OR ace.Type = 6 OR ace.Type = 10 OR ace.Type = 12)
AND NOT ace.Flags & 16 = 16

PRINT 'All explicit "special" permissions, AS listed by Windows Explorer AS "special"'
PRINT 'Advice: for security consideration purposes, should be kept to a minimum'
SELECT 
REPLACE(dbo.GetFullFilePath(@ColID,f.ID),'\\?\UNC\','\\') AS 'NTFS-object',
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
INNER JOIN Accounts a ON a.SidID = s_ace.ID
INNER JOIN AccountTypes t ON t.Type = a.Type
WHERE NOT ace.Mask IN (SELECT ace_m_v.Value FROM AceMaskValues ace_m_v)
AND NOT ace.Flags & 16 = 16

PRINT 'Top-level folders where the folder name is different from the account name that has explicit permissions on the folder (home/profile)'
PRINT 'Advice: for security consideration purposes, only relevant for home & profile folders'
SELECT 
REPLACE(dbo.GetFullFilePath(@ColID,f.ID),'\\?\UNC\','\\') AS 'NTFS-object',
ISNULL(a.Name,s_ace.String) AS 'Permission-account',
ISNULL(a.Domain,'') AS 'Account-domain',
ISNULL(ace_m_v.Text, 'Special') AS 'Rights'
FROM GetFilesByCollID(@ColID) f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
INNER JOIN Acls acl ON acl.ID = sd.DaclID
INNER JOIN AclsVsAces a_a ON a_a.AclID = acl.ID
INNER JOIN Aces ace ON ace.ID = a_a.AceID
INNER JOIN Sids s_ace ON s_ace.ID = ace.SidID
INNER JOIN Accounts a ON a.SidID = s_ace.ID
LEFT JOIN AccountTypes t ON t.Type = a.Type
LEFT JOIN AceMaskValues ace_m_v ON ace_m_v.Value = ace.Mask
WHERE a.Type = 1
AND f.ParentFRN = 0
AND NOT ace.Flags & 16 = 16
AND f.Name <> a.Name

PRINT 'NTFS-objects with SIDs that no longer represent an Active Directory user account or group, or a local computer account'
PRINT 'Advice: should be removed since they are no longer valid permissions, improves NTFS performance'
SELECT
REPLACE(dbo.GetFullFilePath(@ColID,f.ID),'\\?\UNC\','\\') AS 'NTFS-object',
s_ace.String AS 'SID',
ISNULL(ace_m_v.Text, 'Special') AS 'Rights'
FROM GetFilesByCollID(@ColID) f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
INNER JOIN Acls acl ON acl.ID = sd.DaclID
INNER JOIN AclsVsAces a_a ON a_a.AclID = acl.ID
INNER JOIN Aces ace ON ace.ID = a_a.AceID
INNER JOIN Sids s_ace ON s_ace.ID = ace.SidID
INNER JOIN Accounts a ON a.SidID = s_ace.ID
LEFT JOIN AceMaskValues ace_m_v ON ace_m_v.Value = ace.Mask
WHERE NOT ace.Flags & 16 = 16
AND a.Name IS NULL

PRINT 'All explicit permissions where the propagation to sub-objects (CI/OI) has been modified, default = "This folder, subfolders, and files"'
PRINT 'Advice: for careful consideration, disabling propagation causes possible unwanted behavior and reduces readability of permissions'
SELECT 
REPLACE(dbo.GetFullFilePath(@ColID,f.ID),'\\?\UNC\','\\') AS 'NTFS-object',
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
INNER JOIN Accounts a ON a.SidID = s_ace.ID
INNER JOIN AccountTypes t ON t.Type = a.Type
LEFT JOIN AceMaskValues ace_m_v ON ace_m_v.Value = ace.Mask
WHERE NOT (ace.Flags & 1 = 1 AND ace.Flags & 2 = 2)
AND NOT ace.Flags & 16 = 16

PRINT 'All NTFS objects which are protected from the effects of inherited rights'
PRINT 'Advice: for careful consideration, disabling inheritance causes possible unwanted behavior and reduces readability of permissions'
SELECT 
REPLACE(dbo.GetFullFilePath(@ColID,f.ID),'\\?\UNC\','\\') AS 'NTFS-object'
FROM GetFilesByCollID(@ColID) f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
WHERE (sd.SdControl & 4096 = 4096 OR sd.SdControl & 8192 = 8192)

PRINT 'All NTFS objects which have attributes other than "normal", "directory" or "archive"'
PRINT 'Advice: for security/consistency consideration purposes'
SELECT 
REPLACE(dbo.GetFullFilePath(@ColID,f.ID),'\\?\UNC\','\\') AS 'NTFS-object',
(SELECT CASE WHEN f.Attributes & 1 = 1 THEN 'Yes' ELSE 'No' END) AS 'Read-only',
(SELECT CASE WHEN f.Attributes & 2 = 2 THEN 'Yes' ELSE 'No' END) AS 'Hidden',
(SELECT CASE WHEN f.Attributes & 4 = 4 THEN 'Yes' ELSE 'No' END) AS 'System',
(SELECT CASE WHEN f.Attributes & 64 = 64 THEN 'Yes' ELSE 'No' END) AS 'Device',
(SELECT CASE WHEN f.Attributes & 256 = 256 THEN 'Yes' ELSE 'No' END) AS 'Temporary',
(SELECT CASE WHEN f.Attributes & 512 = 512 THEN 'Yes' ELSE 'No' END) AS 'Sparse file',
(SELECT CASE WHEN f.Attributes & 1024 = 1024 THEN 'Yes' ELSE 'No' END) AS 'Reparse point',
(SELECT CASE WHEN f.Attributes & 2048 = 2048 THEN 'Yes' ELSE 'No' END) AS 'Compressed',
(SELECT CASE WHEN f.Attributes & 4096 = 4096 THEN 'Yes' ELSE 'No' END) AS 'Offline',
(SELECT CASE WHEN f.Attributes & 8192 = 8192 THEN 'Yes' ELSE 'No' END) AS 'Not content-indexed',
(SELECT CASE WHEN f.Attributes & 16384 = 16384 THEN 'Yes' ELSE 'No' END) AS 'Encrypted'
FROM GetFilesByCollID(@ColID) f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
WHERE f.Attributes <> 16 AND f.Attributes <> 128 AND f.Attributes <> 32 AND f.Attributes <> 48

DECLARE @table_permissions_explicit_user TABLE (ID bigint, SidID bigint, rights varchar(100))
INSERT INTO @table_permissions_explicit_user
SELECT
f.ID,
a_u.SidID,
ISNULL(ace_m_v.Text, 'Special') AS 'Rights'
FROM Files f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
INNER JOIN Acls acl ON acl.ID = sd.DaclID
INNER JOIN AclsVsAces a_a ON a_a.AclID = acl.ID
INNER JOIN Aces ace ON ace.ID = a_a.AceID
LEFT JOIN AceMaskValues ace_m_v ON ace_m_v.Value = ace.Mask
INNER JOIN Sids s_ace ON s_ace.ID = ace.SidID
INNER JOIN Accounts a_u ON a_u.SidID = s_ace.ID
INNER JOIN AccountTypes t_u ON t_u.Type = a_u.Type
WHERE NOT ace.Flags & 16 = 16
AND t_u.Type = 1

DECLARE @table_permissions_explicit_group TABLE (ID bigint, SidID bigint, rights varchar(100))
INSERT INTO @table_permissions_explicit_group
SELECT
f.ID,
a_u.SidID,
ISNULL(ace_m_v.Text, 'Special') AS 'Rights'
FROM Files f
INNER JOIN SecurityDescriptors sd ON f.SdID = sd.ID
INNER JOIN Acls acl ON acl.ID = sd.DaclID
INNER JOIN AclsVsAces a_a ON a_a.AclID = acl.ID
INNER JOIN Aces ace ON ace.ID = a_a.AceID
LEFT JOIN AceMaskValues ace_m_v ON ace_m_v.Value = ace.Mask
INNER JOIN Sids s_ace ON s_ace.ID = ace.SidID
INNER JOIN Accounts a_u ON a_u.SidID = s_ace.ID
INNER JOIN AccountTypes t_u ON t_u.Type = a_u.Type
WHERE NOT ace.Flags & 16 = 16
AND t_u.Type = 2

PRINT 'All NTFS objects which have explicit permissions for a user account, and also explicit permissions for a group where the user account is a (nested) member of that group'
PRINT 'Advice: check for redundancy since the group permission already gives the user account access'
SELECT DISTINCT
REPLACE(dbo.GetFullFilePath(@ColID,f.ID),'\\?\UNC\','\\') AS 'NTFS-object',
a_u.Name AS 'Permission-account',
p_u.rights AS 'Rights',
a_g.Name AS 'Permission-group',
p_g.rights AS 'Rights'
FROM 
@table_permissions_explicit_user p_u
INNER JOIN Accounts a_u ON p_u.SidID = a_u.SidID
INNER JOIN Files f ON f.ID = p_u.ID
INNER JOIN GetFlattenedGroupsByCollID(@ColID) g ON g.MemberSidID = p_u.SidID -- requires updated function when query errors on maxrecursion
INNER JOIN @table_permissions_explicit_group p_g ON g.SidID = p_g.SidID
INNER JOIN Accounts a_g ON p_g.SidID = a_g.SidID
WHERE p_u.ID = p_g.ID