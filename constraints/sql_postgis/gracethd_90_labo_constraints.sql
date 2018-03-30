/* gracethd_90_labo_constraints.sql */
/* Owner : GraceTHD-Community - http://gracethd-community.github.io/ */
/* Authors : 
stephane dot byache at aleno dot eu
Rémi Desgrange
*/
/* Rev. date : 30/03/2018 */

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
https://redmine.gracethd.org/redmine/issues/431
*/


SET search_path TO gracethd, public;

ALTER TABLE t_masque ADD CONSTRAINT t_masque_mq_col_check CHECK (mq_col > 0);
ALTER TABLE t_masque ADD CONSTRAINT t_masque_mq_ligne_check CHECK (mq_ligne > 0);

ALTER TABLE t_adresse ADD CONSTRAINT t_adresse_ad_majdate_check CHECK (ad_majdate > ad_creadat);
ALTER TABLE t_organisme ADD CONSTRAINT t_organisme_or_majdate_check CHECK (or_majdate > or_creadat);
ALTER TABLE t_reference ADD CONSTRAINT t_reference_rf_majdate_check CHECK (rf_majdate > rf_creadat);
ALTER TABLE t_noeud ADD CONSTRAINT t_noeud_nd_majdate_check CHECK (nd_majdate > nd_creadat);
ALTER TABLE t_znro ADD CONSTRAINT t_znro_zn_majdate_check CHECK (zn_majdate > zn_creadat);
ALTER TABLE t_zsro ADD CONSTRAINT t_zsro_zs_majdate_check CHECK (zs_majdate > zs_creadat);
ALTER TABLE t_zpbo ADD CONSTRAINT t_zpbo_zp_majdate_check CHECK (zp_majdate > zp_creadat);
ALTER TABLE t_zdep ADD CONSTRAINT t_zdep_zd_majdate_check CHECK (zd_majdate > zd_creadat);
ALTER TABLE t_zcoax ADD CONSTRAINT t_zcoax_zc_majdate_check CHECK (zc_majdate > zc_creadat);
ALTER TABLE t_sitetech ADD CONSTRAINT t_sitetech_st_majdate_check CHECK (st_majdate > st_creadat);
ALTER TABLE t_ltech ADD CONSTRAINT t_ltech_lt_majdate_check CHECK (lt_majdate > lt_creadat);
ALTER TABLE t_baie ADD CONSTRAINT t_baie_ba_majdate_check CHECK (ba_majdate > ba_creadat);
ALTER TABLE t_tiroir ADD CONSTRAINT t_tiroir_ti_majdate_check CHECK (ti_majdate > ti_creadat);
ALTER TABLE t_equipement ADD CONSTRAINT t_equipement_eq_majdate_check CHECK (eq_majdate > eq_creadat);
ALTER TABLE t_suf ADD CONSTRAINT t_suf_sf_majdate_check CHECK (sf_majdate > sf_creadat);
ALTER TABLE t_ptech ADD CONSTRAINT t_ptech_pt_majdate_check CHECK (pt_majdate > pt_creadat);
ALTER TABLE t_ebp ADD CONSTRAINT t_ebp_bp_majdate_check CHECK (bp_majdate > bp_creadat);
ALTER TABLE t_cassette ADD CONSTRAINT t_cassette_cs_majdate_check CHECK (cs_majdate > cs_creadat);
ALTER TABLE t_cheminement ADD CONSTRAINT t_cheminement_cm_majdate_check CHECK (cm_majdate > cm_creadat);
ALTER TABLE t_conduite ADD CONSTRAINT t_conduite_cd_majdate_check CHECK (cd_majdate > cd_creadat);
ALTER TABLE t_cond_chem ADD CONSTRAINT t_cond_chem_dm_majdate_check CHECK (dm_majdate > dm_creadat);
ALTER TABLE t_masque ADD CONSTRAINT t_masque_mq_majdate_check CHECK (mq_majdate > mq_creadat);
ALTER TABLE t_cable ADD CONSTRAINT t_cable_cb_majdate_check CHECK (cb_majdate > cb_creadat);
ALTER TABLE t_cableline ADD CONSTRAINT t_cableline_cl_majdate_check CHECK (cl_majdate > cl_creadat);
ALTER TABLE t_cab_cond ADD CONSTRAINT t_cab_cond_cc_majdate_check CHECK (cc_majdate > cc_creadat);
ALTER TABLE t_love ADD CONSTRAINT t_love_lv_majdate_check CHECK (lv_majdate > lv_creadat);
ALTER TABLE t_fibre ADD CONSTRAINT t_fibre_fo_majdate_check CHECK (fo_majdate > fo_creadat);
ALTER TABLE t_position ADD CONSTRAINT t_position_ps_majdate_check CHECK (ps_majdate > ps_creadat);
ALTER TABLE t_ropt ADD CONSTRAINT t_ropt_rt_majdate_check CHECK (rt_majdate > rt_creadat);
ALTER TABLE t_siteemission ADD CONSTRAINT t_siteemission_se_majdate_check CHECK (se_majdate > se_creadat);
ALTER TABLE t_document ADD CONSTRAINT t_document_do_majdate_check CHECK (do_majdate > do_creadat);
ALTER TABLE t_docobj ADD CONSTRAINT t_docobj_od_majdate_check CHECK (od_majdate > od_creadat);
ALTER TABLE t_empreinte ADD CONSTRAINT t_empreinte_em_majdate_check CHECK (em_majdate > em_creadat);

