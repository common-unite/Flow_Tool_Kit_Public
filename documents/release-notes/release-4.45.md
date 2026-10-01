# Release 4.45

Image assets now show on LWR Experience sites.

## 🛠 Visual Picker and background images on LWR sites (#742)

- **Asset images now load on LWR sites.** Visual Picker option images and form, section and header background images used a URL from the domain root, which an LWR site does not serve, so they stayed blank. On a site, Flow Tool Kit now builds the URL from the site's own path (for example `/portal/sfsites/c/file-asset/<asset>`). Lightning Experience, flows in the org and embedded forms keep the URL they used before.
- **After upgrading, publish each LWR site.** An LWR site serves the component code captured at its last publish.
- **Guests on LWR sites** also need **Allow guest users to access public APIs**, and **Let guest users view asset files** for image assets. See [LWR Sites: Setup and Considerations](../experience-cloud/lwr-site-component-support.md).
