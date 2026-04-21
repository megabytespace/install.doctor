---
title: Integrating JumpCloud with pfSense
slug: pfsense-jumpcloud
date: 2023-08-07 14:00:00
author: Brian Zalewski <brian@megabyte.space>
authorUrl: https://twitter.com/HillBillyHack3r
authorName: Brian Zalewski
authorImageName: brian-zalewski.png
authorDescription: Call me BZ, the tech maestro of Megabyte Labs by day, gym enthusiast, party animal, and ball game champion by night. Always up for a quirky chat about AI, deities, or time-hopping. Plotting world betterment one inspiration at a time.
description: Instructions on how to configure pfSense to work with JumpCloud
featuredImage: /self-service-portal.png
featuredImageAlt: pfSense JumpCloud graphic
tags: pfSense,JumpCloud,LDAP
---

Acquire certificate required for connecting JumpCloud to pfSense.

JumpCloud LDAPS Certificate (goes under Certificates tab)


```shell
echo -n | openssl s_client -connect ldap.jumpcloud.com:636 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /tmp/jumpcloud.ldap.pem
```

Certificate Authority (goes under CAs tab)

```shell
echo -n | openssl s_client -connect ldap.jumpcloud.com:636 -showcerts | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /tmp/jumpcloud.chain.pem
```
