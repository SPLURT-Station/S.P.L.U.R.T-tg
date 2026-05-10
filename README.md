+-------------------+       +-------------------+       +-------------------+
|   React Frontend  | <---> |   Node.js API     | <---> |   PostgreSQL DB   |
| (axios, styled‑) |       | (Express, Sequelize) |    | (pg, pg‑hstore) |
+-------------------+       +-------------------+       +-------------------+

All components are containerised:
- backend/
- frontend/
- db/