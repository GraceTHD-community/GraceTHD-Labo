/* gracethd_90_labo_constraints.sql */
/* Owner : GraceTHD-Community - http://gracethd-community.github.io/ */
/* Authors : 
stephane dot byache at aleno dot eu
Rémi Desgrange
*/
/* Rev. date : 21/02/2018 */

/* ********************************************************************
    This file is part of GraceTHD.

    GraceTHD is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    GraceTHD is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with GraceTHD.  If not, see <http://www.gnu.org/licenses/>.
*********************************************************************** */


/*Objectif : 
Permettre à la communauté de partager des ajouts "optionnels" de contraintes sur une base GraceTHD-MCD. 
*/

/*Utilisation : 
Possibilité de coller le contenu de ce script dans votre fichier .\sql_postgis\gracethd_90_labo.sql. 
*/

/*Conception : 
https://redmine.gracethd.org/redmine/issues/429
*/


SET search_path TO gracethd, public;

ALTER TABLE t_masque ADD CONSTRAINT t_masque_mq_col_check CHECK (mq_col > 0);
ALTER TABLE t_masque ADD CONSTRAINT t_masque_mq_ligne_check CHECK (mq_ligne > 0);
ALTER TABLE t_masque ADD CONSTRAINT t_masque_mq_majdate_check CHECK (mq_majdate > mq_creadat);
