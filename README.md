### About This Block
- BLOCK CATEGORY: Sales Analytics
- SUBCATEGORY BLOCK NAME: Salesforce
- DIALECTS: PL/pgSQL (PostgreSQL, Redshift, Greenplum), Microsoft SQL Server (2012+)
- ASSUMPTIONS: 
    - The schema contains the following base objects/relations: account, contact, campaign, lead, opportunity, and user
    - It is assumed that when a lead converts, both an opportunity and an account are created.
- CONSIDERATIONS:
	- Included in this block are submodules for additional Salesforce entities, which are not considered "base" objects. Those optional submodules include: `opportunity_history` for pipeline analysis, `campaign_member` for campaign attribution, and `task` for meeting/outreach analysis.
	- Another submodule is the switchboard pattern, which provides a way to view all entities in a single place. It's also a pattern that lends itself to funnel analysis and campaign attribution in a single explore/base view.

Contact scott@looker.com or segah@looker.com for clarification when applying these Salesforce patterns.