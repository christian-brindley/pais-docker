/*
 * Copyright 2018-2025 Ping Identity Corporation. All Rights Reserved
 *
 * This code is to be used exclusively in connection with Ping Identity
 * Corporation software or services. Ping Identity Corporation only offers
 * such software or services to legal entities who have entered into a
 * binding license agreement with Ping Identity Corporation.
 */
ds.addBackendWithDefaultUserIndexes backendName, baseDn

ds.addSchemaFiles()
ds.addIndex "sun-fm-saml2-nameid-infokey", "equality"
ds.addIndex "iplanet-am-user-alias-list", "equality"
ds.addIndex "pwdChangedTime", "ordering"

/*
 * Generic frIndexed / frUnindexed managed object attributes (fr-attr-*).
 * These map onto the fr-ext-attrs auxiliary object class defined in
 * 99-idm-ext-attrs-schema.ldif. Indexing mirrors what the PingOne AIC
 * cloud directory provides out of the box; only indexed attributes get
 * backend indexes. Multivalued attributes get both equality and substring.
 */
ds.addIndex "fr-attr-istr1", "equality"
ds.addIndex "fr-attr-istr2", "equality"
ds.addIndex "fr-attr-istr3", "equality"
ds.addIndex "fr-attr-istr4", "equality"
ds.addIndex "fr-attr-istr5", "equality"
ds.addIndex "fr-attr-istr6", "equality"
ds.addIndex "fr-attr-istr7", "equality"
ds.addIndex "fr-attr-istr8", "equality"
ds.addIndex "fr-attr-istr9", "equality"
ds.addIndex "fr-attr-istr10", "equality"
ds.addIndex "fr-attr-istr11", "equality"
ds.addIndex "fr-attr-istr12", "equality"
ds.addIndex "fr-attr-istr13", "equality"
ds.addIndex "fr-attr-istr14", "equality"
ds.addIndex "fr-attr-istr15", "equality"
ds.addIndex "fr-attr-istr16", "equality"
ds.addIndex "fr-attr-istr17", "equality"
ds.addIndex "fr-attr-istr18", "equality"
ds.addIndex "fr-attr-istr19", "equality"
ds.addIndex "fr-attr-istr20", "equality"
ds.addIndex "fr-attr-iint1", "equality"
ds.addIndex "fr-attr-iint2", "equality"
ds.addIndex "fr-attr-iint3", "equality"
ds.addIndex "fr-attr-iint4", "equality"
ds.addIndex "fr-attr-iint5", "equality"
ds.addIndex "fr-attr-idate1", "equality"
ds.addIndex "fr-attr-idate2", "equality"
ds.addIndex "fr-attr-idate3", "equality"
ds.addIndex "fr-attr-idate4", "equality"
ds.addIndex "fr-attr-idate5", "equality"
ds.addIndex "fr-attr-imulti1", "equality"
ds.addIndex "fr-attr-imulti2", "equality"
ds.addIndex "fr-attr-imulti3", "equality"
ds.addIndex "fr-attr-imulti4", "equality"
ds.addIndex "fr-attr-imulti5", "equality"
ds.addIndex "fr-idm-agent-origin", "equality"
ds.addIndex "fr-idm-identity-type", "equality"

/*
 * fr-idm-agent-identity-reference stores name-and-json references (same
 * syntax and matching rule as fr-idm-owners-reference), so it needs a
 * big-extensible index rather than a standard equality index.
 */
ds.config "create-backend-index",
        "--index-name", "fr-idm-agent-identity-reference",
        "--backend-name", backendName,
        "--set", "index-type:big-extensible",
        "--set", "big-index-extensible-matching-rule:1.3.6.1.4.1.36733.2.1.4.7",
        "--set", "big-index-extensible-matching-rule:1.3.6.1.4.1.36733.2.1.4.8"

ds.importLdifTemplate "base-entries.ldif"

/*
 * This template-based virtual attribute is used to calculate the memberURl attribute for groups.
 * Due to the filter, this attribute will only be calculated for those groups which are of all three objectClasses:
 * "top", "groupOfURLs", and "fr-idm-managed-group"
 * It is created in the AM profile instead of the IDM profile, even though it references IDM schema elements, because:
 * 1. AM stores the groups objects
 * 2. The baseDn is defined in the AM profile
 */
ds.config "create-virtual-attribute",
        "--name", "virtual memberURL",
        "--type", "user-template",
        "--set", "base-dn:ou=groups,${baseDn}",
        "--set", "enabled:true",
        "--set", "attribute-type:memberURL",
        "--set", "template:ldap:///ou=people,${baseDn}??sub?fr-idm-effectiveGroup:caseIgnoreJsonQueryMatch:=_refResourceId eq \"{cn}\"",
        "--set", "conflict-behavior:virtual-overrides-real",
        "--set", "filter:(&(objectClass=top)(objectClass=groupOfURLs)(objectClass=fr-idm-managed-group))"
