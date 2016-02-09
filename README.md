### About This Block
- BLOCK CATEGORY: Sales Analytics
- SUBCATEGORY BLOCK NAME: Salesforce
- DIALECTS: PL/pgSQL (PostgreSQL, Redshift, Greenplum), Microsoft SQL Server (2012+)
- ASSUMPTIONS: 
    - The schema contains the following base objects/relations: account, contact, campaign, lead, opportunity, and user
    - It is assumed that when a lead converts, both an opportunity and an account are created.
- CONSIDERATIONS:
	- The "Base Block" is built upon the subset of objects found across (nearly) all Salesforce instances
	- Included in this block are also submodules for additional Salesforce entities, which are not considered "base" objects. Those optional submodules include: `opportunity_history` for pipeline analysis, `campaign_member` for campaign attribution, and `task` for meeting/outreach analysis.
	- To implement a submodule, The assumption here is that the customer has certain "non-standard" objects present in order to implement the submodules.
	- One submodule is the switchboard pattern, which provides a way to view all entities in a single place. It's also a pattern that lends itself to funnel analysis and campaign attribution in a single explore/base view.


###I. Base Blocks

####Account-level revenue:
a. Freshly generated view files for Account, Campaign, Contact, Lead, Opportunity, and User.
b. sf_extends.view.lookml, which is where all embellished dimensions and measures are built.
c. salesforce.model.lookml, where base views are declared.
d. Four dashboards: Marketing Leadership, Ops Management, Rep Performance, and Team Summary.

####Lead-level revenue:
a. Variant view files for Account, Campaign, Contact, Lead, Opportunity, and User.
b. salesforce.model.lookml, where base views are declared.

###II. Submodules

####Campaign Attribution (requires `CampaignMember` and `Task` objects)
a. Freshly generated view files for campaign member and task.
b. sf_extends.view.lookml, which is where all embellished dimensions and measures are built.
c. salesforce.model.lookml, which is where base views are declared; add base views to core model if present.
d. attribution.view.lookml, which takes a sessions-based approach to attribution. Specifically, different people at a given company may have seen different campaigns over time, perhaps with lulls in their interactions. We want to look at the cluster of campaign touches that preceded a meeting and attribute a meeting or opportunity to the first campaign of that cluster.

####Opportunity Snapshot (requires `OpportunityHistory` object)
a. Freshly generated view file for opportunity history
b. A date-table pattern
c. historical_snapshot.view.lookml, which is a PDT that uses a date join to fan out opportunity history so that we know the states and amounts associated with opportunities on any given day.
d. opportunity_facts.view.lookml, account-level fact table of opportunity information.
e. sf_extends.view.lookml, which is where all embellished dimensions and measures should be built (no additional fields present yet).
f. salesforce.model.view, which is where base views are declared; add base views to core model if present.
g. One opportunity-snapshot dashboard.

####The Switchboard (`CampaignMember` and `Task` objects are optional)
a. the_switchboard_limited.view.lookml which is the switchboard pattern, using only the core objects.
b. the_switchboard_complete.view.lookml which is the switchboard (360 view) pattern, the core objects plus `CampaignMember` and `Task`
c. salesforce.model.lookml, which is where base views are declared; add base views to core model if present.

Contact scott@looker.com or segah@looker.com for clarification when applying these Salesforce patterns.
