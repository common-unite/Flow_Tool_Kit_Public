# Unreleased: guest form load with a subscriber field twin (#699)

Guest visitors no longer get "Form Load Error" when a subscriber field shares its API name with a packaged FlowToolKit field; the form field dictionary now resolves fields by durable id instead of relationship traversal. The rebuild is also faster: about 85 ms instead of about 1.1 s for an admin in a 130-field org.
