Thank you for using Looker's Salesforce Block. Below, we've provided a brief overview of the Block components. For assistance implementing any of the included patterns, please reach out to your assigned Looker Analyst or Looker Support.

### About This Block
- Dialects: 
    - PL/pgSQL (PostgreSQL, Redshift, Greenplum), Microsoft SQL Server (2012+)
- Assumptions: 
    - The schema contains the following base objects/relations: `account`, `contact`, `campaign`, `lead`, `opportunity`, and `user`
    - It is assumed that when a lead converts, both an opportunity and an account are created.
- Considerations:
	- The "Base Block" is built upon the subset of objects found across (nearly) all Salesforce instances
	- Included in this block are also submodules for additional Salesforce entities, which are not considered "base" objects. Those optional submodules include: `opportunity_history` for pipeline analysis, `campaign_member` for campaign attribution, and `task` for meeting/outreach analysis.
	- To implement a submodule, The assumption here is that the customer has certain "non-standard" objects present in order to implement the submodules.
	- One submodule is the switchboard pattern, which provides a way to view all entities in a single place. It's also a pattern that lends itself to funnel analysis and campaign attribution in a single explore/base view.


### I. Base Block

##### 1. Account-level Revenue:
- Freshly generated view files for `Account`, `Campaign`, `Contact`, `Lead`, `Opportunity`, and `User`
- `sf_extends.view.lookml`, which is where all embellished dimensions and measures are built
- `salesforce.model.lookml`, where base views are declared
- Four dashboards: Marketing Leadership, Ops Management, Rep Performance, and Team Summary

##### 2. Lead-level Revenue:
- Variant view files for `Account`, `Campaign`, `Contact`, `Lead`, `Opportunity`, and `User`
- `salesforce.model.lookml`, where base views are declared

### II. Submodules

##### 1. Campaign Attribution (requires `CampaignMember` and `Task` objects)
- Freshly generated view files for `campaignmember` and `task`.
- `sf_extends.view.lookml`, which is where all embellished dimensions and measures are built.
- `salesforce.model.lookml`, which is where base views are declared; add base views to core model if present.
- `attribution.view.lookml`, which takes a sessions-based approach to attribution. Specifically, different people at a given company may have seen different campaigns over time, perhaps with lulls in their interactions. We want to look at the cluster of campaign touches that preceded a meeting and attribute a meeting or opportunity to the first campaign of that cluster.

##### 2. Opportunity Snapshot (requires `OpportunityHistory` object)
- Freshly generated view file for `opportunityhistory`
- A date-table pattern
- `historical_snapshot.view.lookml`, which is a PDT that uses a date join to fan out opportunity history so that we know the states and amounts associated with opportunities on any given day.
- opportunity_facts.view.lookml, account-level fact table of opportunity information.
- `sf_extends.view.lookml`, which is where all embellished dimensions and measures should be built (no additional fields present yet).
- `salesforce.model.view`, which is where base views are declared; add base views to core model if present.
- One opportunity-snapshot dashboard.

##### 3. The Switchboard (`CampaignMember` and `Task` objects are optional)
- `the_switchboard_limited.view.lookml` which is the switchboard pattern, using only the core objects.
- `the_switchboard_complete.view.lookml` which is the switchboard (360 view) pattern, the core objects plus `CampaignMember` and `Task`
- `salesforce.model.lookml`, which is where base views are declared; add base views to core model if present.
