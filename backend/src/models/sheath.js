/**
 * @file backend/src/models/sheath.js
 * @description Sequelize model definition for a Sheath entity.
 * @module models/sheath
 */

'use strict';

const { DataTypes, Model } = require('sequelize');
const logger = require('../utils/logger'); // Assuming a logger utility is present

/**
 * @class Sheath
 * @extends Model
 * @property {number} id - Primary key.
 * @property {string} name - Human‑readable name.
 * @property {string} material - Material composition (e.g., steel, plastic).
 * @property {number} length - Length in millimetres.
 * @property {number} diameter - Inner diameter in millimetres.
 * @property {Date} createdAt - Record creation timestamp.
 * @property {Date} updatedAt - Record update timestamp.
 */
class Sheath extends Model {
  /**
   * Initialize the model within a Sequelize instance.
   * @param {import('sequelize').Sequelize} sequelize - Sequelize connection.
   * @returns {typeof Sheath} The initialized model.
   */
  static initModel(sequelize) {
    Sheath.init(
      {
        id: {
          type: DataTypes.INTEGER.UNSIGNED,
          primaryKey: true,
          autoIncrement: true,
        },
        name: {
          type: DataTypes.STRING(255),
          allowNull: false,
          validate: {
            notEmpty: { msg: 'Name must not be empty' },
            len: { args: [1, 255], msg: 'Name length must be between 1 and 255 characters' },
          },
        },
        material: {
          type: DataTypes.STRING(100),
          allowNull: false,
          validate: {
            notEmpty: { msg: 'Material must not be empty' },
            isIn: {
              args: [['steel', 'plastic', 'composite', 'titanium']],
              msg: 'Material must be one of the predefined types',
            },
          },
        },
        length: {
          type: DataTypes.FLOAT,
          allowNull: false,
          validate: {
            isFloat: { msg: 'Length must be a numeric value' },
            min: { args: [0.1], msg: 'Length must be greater than zero' },
          },
        },
        diameter: {
          type: DataTypes.FLOAT,
          allowNull: false,
          validate: {
            isFloat: { msg: 'Diameter must be a numeric value' },
            min: { args: [0.1], msg: 'Diameter must be greater than zero' },
          },
        },
      },
      {
        sequelize,
        modelName: 'Sheath',
        tableName: 'sheaths',
        timestamps: true,
        underscored: true,
        hooks: {
          beforeValidate(sheath) {
            logger.debug(`Validating Sheath: ${JSON.stringify(sheath.toJSON())}`);
          },
          afterCreate(sheath) {
            logger.info(`Sheath created with ID ${sheath.id}`);
          },
          afterUpdate(sheath) {
            logger.info(`Sheath updated (ID ${sheath.id})`);
          },
          afterDestroy(sheath) {
            logger.warn(`Sheath deleted (ID ${sheath.id})`);
          },
        },
      }
    );

    // Define any associations here if needed
    // Example:
    // Sheath.associate = (models) => {
    //   Sheath.hasMany(models.Slit, { foreignKey: 'sheath_id', as: 'slits' });
    // };

    return Sheath;
  }
}

module.exports = Sheath;