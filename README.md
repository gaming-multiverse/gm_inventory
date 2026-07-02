# gm_inventory (Modified version of ox_inventory to work for RedM)

## Overview
This is a modified version of the `ox_inventory` script originally created by the Overextended team. The script includes the following changes:

- Full RSG Support
- Compatibility with rdr3 natives
- Bug fixes found in the original [fork of this repository](https://github.com/Faroeste-Roleplay/ox_inventory)

## Original Project
The original project can be found here: [overextended/ox_inventory](https://github.com/overextended/ox_inventory)

Huge thanks for the most heavy lifting and original conversion of the maintiner of [frp-framework](https://github.com/Faroeste-Roleplay)

## Disclaimer
We do not claim ownership of this resource nor do we claim credit for converting it to RedM this work has been put together
by the owner and maintainer of FRP-FRAMEWORK that managed to convert most of the stuff to work on RedM. We simply took the fork made it compatible with RSG and fixed alot of the issues found on the [original repository](https://github.com/Faroeste-Roleplay/ox_inventory)

## License
This project is licensed under the GNU General Public License v3.0 (GPL-3.0). See the `LICENSE` file for more details.

## Attribution
The original `ox_inventory` script is credited to the Overextended team.
Modifications were made originaly by the [frp team](https://discord.gg/uVDf5kGbB8) & later fixed and improved by [Gaming Multiverse](https://github.com/gaming-multiverse).

## Dependencies
- [jo_libs](https://github.com/Jump-On-Studios/RedM-jo_libs)

## Changes in your server.cfg (place these at the bottom of your server.cfg)
```
setr inventory:dropprops true
setr inventory:dropmodel "p_sack04x"
setr inventory:slots 30
setr inventory:weight 50000
setr inventory:slotsServerTag 40
setr inventory:weightServerTag 60000
setr inventory:serverTag "discord_server_tag"
setr inventory:serverTagRefreshInterval 30
setr inventory:slotsVIP 55
setr inventory:weightVIP 75000
```

## Build & UI Info

### Web based testing
- Navigate to `web/`
- Open the terminal/cmd and type:
    - if you use npm
        - `npm i`
    - if you use bun
        - `bun i`
    - if you use pnpm
        - `pnpm install`
- After that is done you can start the development server by typing:
    - if you use npm
        - `npm run start`
    - if you use bun
        - `bun run start`
    - if you use pnpm
        - `pnpm run start`

### Building the UI
If you cloned the repository and didn't use the releases page you will need to do the following
- Navigate to `web/`
- Open the terminal/cmd and type:
    - if you use npm
        - `npm i`
    - if you use bun
        - `bun i`
    - if you use pnpm
        - `pnpm install`
- Once that completes you can do the following:
    - if you use npm
        - `npm run build`
    - if you use bun
        - `bun run build`
    - if you use pnpm
        - `pnpm run build`
    - Then a folder build will be created
- That should be it now you can use the inventory!

## Acknowledgments
Special thanks to the Overextended team for creating the original `ox_inventory` project and contributing to the RedM and FiveM communities.

---
For questions or issues, feel free to contact us on our discord at https://discord.gg/ERmEPsafmR

