---
title: Netdata Integration
description: Learn about how Install Doctor integrates Netdata to provide a free, cloud-hosted dashboard where you can view charts and metrics that cover all your most important device metrics.
sidebar_label: Netdata
slug: /integrations/netdata
---

Install Doctor allows the user to monitor detailed system metrics by leveraging Netdata. The **free** web service provides a useful, slick, detailed interface where you can browse through charts that detail important metrics like the amount of RAM being used. The service manages to offer an amazing free service because they offer a paid upgrade that features extended log rentention (among a few other features).

<figure>
  <picture>
    <source src="/docs/screenshots/netdata-localhost.png" type="image/png" />
    <source src="/docs/screenshots/netdata-localhost.webp" type="image/webp" />
    <img src="/docs/screenshots/netdata-localhost.png" alt="Netdata localhost screenshot" loading="eager" />
  </picture>
  <figcaption>Screenshot of the localhost version of Netdata (i.e. http://localhost:19999)</figcaption>
</figure>

## Configuration

To automate the provisioning process of Netdata, you need to make several variables available for Install Doctor (otherwise, you will only be able to access the device's local Netdata dashboard at `http://localhost:19999` when the service is running). These variables include:

* `NETDATA_TOKEN` - This is the `--claim-token` data value shown by the Netdata cloud service app start page when you first login to [Netdata Cloud](https://app.netdata.cloud)
* `NETDATA_ROOM` - This is the `--claim-rooms` data value shown by the Netdata cloud service page that is displayed when you first create a new room

Using the methods described in the [Secrets documentation](https://install.doctor/docs/integrations/netdata), you can provide Install Doctor with these data points so that it can automatically configure and connect your local Netdata instances to the free Netdata Cloud service.

## Alerts

The Netdata service can be configured to automatically dispatch alerts when system parameters match certain triggers. For more details, see [Netdata's documentation on setting up alerts](https://learn.netdata.cloud/docs/alerts-and-notifications/configure-alerts).

A handful of cloud notification services, including e-mail, are integrated into the default configuration via the [Netdata notification configuration](https://github.com/megabyte-labs/install.doctor/blob/master/home/dot_config/netdata/health_alarm_notify.conf.tmpl). With this configuration and secrets specified in [`home/.chezmoitemplates/secrets`](https://github.com/megabyte-labs/install.doctor/tree/master/home/.chezmoitemplates/secrets), you can headlessly deploy Netdata coupled with notification systems.

## TODO

* [GitHub feature request for sensible Netdata defaults](https://github.com/megabyte-labs/install.doctor/issues/18)
