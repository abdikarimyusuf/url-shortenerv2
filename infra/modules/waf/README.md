Web ACL                    ← Main WAF security rulebook

Rule                       ← Individual security check

Priority                   ← Determines the order rules are evaluated

Statement                  ← Defines WHAT the rule checks

IP Set                     ← Collection of IP addresses to check against

Rate-Based Statement       ← Checks whether request rate exceeds a limit

Managed Rule Group         ← Pre-built security rules provided by AWS

Action                     ← Defines WHAT happens when the rule matches

ALLOW                      ← Allow the request through

BLOCK                      ← Reject the request

COUNT                      ← Count the request but allow it to continue

CAPTCHA                    ← Ask the user to complete a CAPTCHA

CHALLENGE                  ← Ask the requester to prove they are legitimate

Visibility Config          ← Controls WAF monitoring and metrics

CloudWatch Metrics         ← Provides WAF metrics for monitoring

Web ACL Association        ← Connects the WAF Web ACL to the ALB
The core WAF structure
Web ACL                    ← Security rulebook
   ↓
Rule                       ← Individual security check
   ↓
Statement                  ← WHAT are we checking?
   ↓
Match?                     ← Does the request meet the condition?
   ↓
Action                     ← WHAT should WAF do?
   ↓
ALLOW / BLOCK / COUNT      ← Result
Example
Rule                       ← "Block bad IPs"

Statement                  ← Check the request's source IP

IP Set                     ← Contains blocked IP addresses

Match?                     ← Is the source IP in the IP Set?

YES                        ← Apply the rule's action

BLOCK                      ← Reject the request



You might see:

CloudWatch metrics
        ↓
150 requests matched

And with:

sampled_requests_enabled = true

you can inspect sampled examples of those requests in the WAF console.



OBJECT
= Data + behavior bundled together in Java

SERIALIZATION
= Object → Data

DESERIALIZATION
= Data → Object

MALICIOUS OBJECT/DATA
= Specially crafted data designed to abuse
  how the application rebuilds/handles objects

RCE
= Remote Code Execution
= attacker may cause the server to execute
  unintended code remotely


chosen rule:
AWSManagedRulesCommonRuleSet

Protects against common web attack patterns, including common malicious request structures.

AWSManagedRulesKnownBadInputsRuleSet

Looks for known malicious input patterns.

AWSManagedRulesAmazonIpReputationList

Blocks requests associated with IP addresses known to be malicious.

AWSManagedRulesSQLiRuleSet

Helps detect SQL injection attempts.

