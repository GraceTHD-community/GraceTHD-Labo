/* gracethd_90_labo_objects.sql */
/* Owner : GraceTHD-Community - http://gracethd-community.github.io/ */
/* Author : stephane dot byache at aleno dot eu */
/* Rev. date : 16/03/2018 */

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


/*PostGIS*/

SET search_path TO gracethd, public;


/*Génération d'"itinéraires" (entre cm_ndcode1 et nd_code2 agrégations Linestrings si la topologie est propre, sinon multilinestrings)*/
DROP VIEW IF EXISTS vs_obj_it;
CREATE VIEW vs_obj_it AS
SELECT 
    'IT' || cm_ndcode1 || cm_ndcode2 AS it_id, --id d'itinéraire calculé
    cm_ndcode1 AS it_ndcode1, --doit correspondre à un PT, ST, SF, SE ou ND type disjonction. Pas de ND type spécifique. 
    cm_ndcode2 AS it_ndcode2, --doit correspondre à un PT, ST, SF, SE ou ND type disjonction. Pas de ND type spécifique. 
    cm_r1_code AS it_r1_code, 
    cm_r2_code AS it_r2_code, 
    cm_r3_code AS it_r3_code, 
    cm_statut AS it_statut, --ça peut varier entre 2 PT mais il faut au moins une info sur l'avancement
    --cm_etat AS it_etat, --non retenu, un état peut varier sur un cheminement précis
    --cm_avct AS it_avct, --non retenu, ça peut varier entre 2 ND
    cm_typ_imp AS it_typ_imp, --noeuds de disjonction nécessaires. 
	cm_cddispo AS it_cddispo, --noeuds de disjonction nécessaires. 
	cm_fo_util AS it_fo_util, --noeuds de disjonction nécessaires. 
    sum(cm_long) AS it_long, --somme des cm_long
    sum(cm_lgreel) AS it_lgreel, --somme des cm_lgreel
    ST_LENGTH(ST_Linemerge(ST_Collect(geom))) AS it_lggeom, --longueur calculée de la géométrie générée. 
    count(*) AS it_nb_cm, --nbr de cheminements composant l'itinéraire
    ST_IsValidReason(ST_Linemerge(ST_Collect(geom))) AS it_isvalid, --cause si géométrie invalide. 
    ST_GeometryType(ST_Linemerge(ST_Collect(geom))) AS it_geomtyp, --type de géométrie
    ST_Linemerge(ST_Collect(geom)) AS it_geom
FROM t_cheminement
WHERE cm_ndcode1 IS NOT NULL AND cm_ndcode2 IS NOT NULL
GROUP BY 
	cm_ndcode1, 
	cm_ndcode2, 
	cm_r1_code, 
	cm_r2_code, 
	cm_r3_code, 
	cm_statut, 
	--cm_etat, 
	--cm_avct, 
	cm_typ_imp, 
	cm_cddispo, 
	cm_fo_util
ORDER BY it_id;


/*Relations "itinéraires" calculés / cheminements*/
DROP VIEW IF EXISTS v_obj_it_cm;
CREATE VIEW v_obj_it_cm AS
SELECT
    'IT' || cm_ndcode1 || cm_ndcode2 AS it_id, --id d'itinéraire calculé
	cm_code
FROM t_cheminement
WHERE cm_ndcode1 IS NOT NULL AND cm_ndcode2 IS NOT NULL
;

/*Génération de conduites (Linestrings si la topologie est propre, sinon multilinestrings)*/
DROP VIEW IF EXISTS vs_obj_cd;
CREATE VIEW vs_obj_cd AS
SELECT
    cd_code,
    cd_codeext,
    cd_etiquet,
    cd_r1_code,
    cd_r2_code,
    cd_r3_code,
    cd_r4_code,
    cd_prop,
    cd_gest,
    cd_user,
    cd_proptyp,
    cd_statut,
    cd_etat,
    cd_dateaig,
    cd_dateman,
    cd_datemes,
    cd_avct,
    cd_type,
    cd_dia_int,
    cd_dia_ext,
    cd_color,
    cd_long,
    cd_nbcable,
    cd_occup,
    cd_comment,
    cd_creadat,
    cd_majdate,
    cd_majsrc,
    cd_abddate,
    cd_abdsrc,
    ST_Length(ST_Linemerge(ST_Collect(geom))) AS cd_geomlng,
    count(*) AS cd_nb_cm, --nbr de cheminements composant l'itinéraire
    ST_IsValidReason(ST_Linemerge(ST_Collect(geom))) AS cd_isvalid, --cause si géométrie invalide. 
    ST_GeometryType(ST_Linemerge(ST_Collect(geom))) AS cd_geomtyp, --type de géométrie
    ST_Linemerge(ST_Collect(geom)) AS cd_geom
FROM vs_elem_cd_dm_cm
--FROM t_conduite AS CD
WHERE cm_ndcode1 IS NOT NULL AND cm_ndcode2 IS NOT NULL
Group by
    cd_code,
    cd_codeext,
    cd_etiquet,
    cd_r1_code,
    cd_r2_code,
    cd_r3_code,
    cd_r4_code,
    cd_prop,
    cd_gest,
    cd_user,
    cd_proptyp,
    cd_statut,
    cd_etat,
    cd_dateaig,
    cd_dateman,
    cd_datemes,
    cd_avct,
    cd_type,
    cd_dia_int,
    cd_dia_ext,
    cd_color,
    cd_long,
    cd_nbcable,
    cd_occup,
    cd_comment,
    cd_creadat,
    cd_majdate,
    cd_majsrc,
    cd_abddate,
    cd_abdsrc
ORDER BY cd_code
;


/*Indicateur : Les cheminements qui n'ont pas de conduites*/
DROP VIEW IF EXISTS vs_in_1_cm0cd;
CREATE VIEW vs_in_1_cm0cd AS
SELECT 
    *
FROM t_cheminement AS CM
    LEFT JOIN t_cond_chem AS DM ON CM.cm_code=DM.dm_cm_code
    LEFT JOIN t_conduite AS CD ON CD.cd_code=DM.dm_cd_code
WHERE CD.cd_code IS NULL
;


/*Les plans de boites (et de tiroirs)*/
DROP VIEW IF EXISTS v_obj_ps;
CREATE VIEW v_obj_ps AS
SELECT --*
	PS.ps_code,
	PS.ps_ti_code,
	--TI.ti_etiquet,	
	BP.bp_code,
	--BP.bp_etiquet,
	PS.ps_cs_code,
	--CB1.cb_etiquet AS cb1_etiquet,
	CB1.cb_code AS cb1_code,
	--FO1.fo_code AS fo_code1,
	FO1.fo_nincab AS fo1_nincab, --Numéro de fibre dans le câble
	FO1.fo_numtub AS fo1_numtub, --Numéro du tube auquel appartient la fibre
	FO1.fo_reper AS fo1_reper, --Repérage du tube
	FO1.fo_nintub AS fo1_nintub, --Numéro de la fibre dans le tube (1 à 12, …)
	FO1.fo_color AS fo1_color, --Numéro de fibre selon le code couleur
	PS.ps_1,
	PS.ps_2,
	--FO2.fo_code AS fo_code2,
	FO2.fo_color AS fo2_color, --Numéro de fibre selon le code couleur	
	FO2.fo_nintub AS fo2_nintub, --Numéro de la fibre dans le tube (1 à 12, …)
	FO2.fo_reper AS fo2_reper, --Repérage du tube
	FO2.fo_numtub AS fo2_numtub, --Numéro du tube auquel appartient la fibre
	FO2.fo_nincab AS fo2_nincab, --Numéro de fibre dans le câble
	CB2.cb_code AS cb2_code,
	--CB2.cb_etiquet AS cb2_etiquet,
	PS.ps_type,
	PS.ps_fonct,
	PS.ps_etat,
	PS.ps_preaff,
	PS.ps_comment,
	PS.ps_creadat,
	PS.ps_majdate,
	PS.ps_majsrc,
	PS.ps_abddate,
	PS.ps_abdsrc
FROM t_position AS PS
	LEFT JOIN t_fibre AS FO1 ON PS.ps_1=FO1.fo_code
	LEFT JOIN t_cable AS CB1 ON FO1.fo_cb_code=CB1.cb_code
	LEFT JOIN t_fibre AS FO2 ON PS.ps_2=FO2.fo_code
	LEFT JOIN t_cable AS CB2 ON FO2.fo_cb_code=CB2.cb_code
	LEFT JOIN t_cassette AS CS ON PS.ps_cs_code=CS.cs_code
	LEFT JOIN t_ebp AS BP ON CS.cs_bp_code=BP.bp_code
	LEFT JOIN t_tiroir AS TI ON PS.ps_ti_code=TI.ti_code
--WHERE CB1.cb_capafo = CB2.cb_capafo
ORDER BY ps_ti_code, bp_code, ps_cs_code, cb1_code, fo1_nincab, cb2_code, fo2_nincab
;

/*Plan de baie*/
DROP VIEW IF EXISTS v_obj_ba;
CREATE VIEW v_obj_ba AS
SELECT 
	ba_code,
	ba_codeext,
	ba_etiquet,
	ba_lt_code,
	ba_prop,
	ba_gest,
	ba_user,
	ba_proptyp,
	ba_statut,
	ba_etat,
	ba_rf_code,
	ba_type,
	ba_nb_u,
	ba_haut,
	ba_larg,
	ba_prof,
	ba_comment,
	ba_creadat,
	ba_majdate,
	ba_majsrc,
	ba_abddate,
	ba_abdsrc,
	ti.ti_code AS et_code,
	ti_codeext AS et_codeext,
	ti_etiquet AS et_etiquet,
	ti_ba_code AS et_ba_code,
	ti_prop AS et_prop,
	ti_etat AS et_etat,
	ti_type AS et_type,
	ti_rf_code AS et_rf_code,
	NULL AS et_dateins, --abs ti
	NULL AS et_datemes, --abs ti
	ti_taille AS et_taille,
	ti_placemt AS et_placemt,
	ti_localis AS et_localis,
	ti_comment AS et_comment,
	ti_creadat AS et_creadat,
	ti_majdate AS et_majdate,
	ti_majsrc AS et_majsrc,
	ti_abddate AS et_abddate,
	ti_abdsrc AS et_absrc
FROM t_tiroir AS TI 
	LEFT JOIN t_baie AS BA ON TI.ti_ba_code = BA.ba_code
UNION
SELECT 
	ba_code,
	ba_codeext,
	ba_etiquet,
	ba_lt_code,
	ba_prop,
	ba_gest,
	ba_user,
	ba_proptyp,
	ba_statut,
	ba_etat,
	ba_rf_code,
	ba_type,
	ba_nb_u,
	ba_haut,
	ba_larg,
	ba_prof,
	ba_comment,
	ba_creadat,
	ba_majdate,
	ba_majsrc,
	ba_abddate,
	ba_abdsrc,
	eq.eq_code AS et_code,
	eq_codeext AS et_codeext,
	eq_etiquet AS et_etiquet,
	eq_ba_code AS et_ba_code,
	eq_prop AS et_prop,
	NULL AS et_etat, --abs eq
	NULL AS et_type, --abs eq
	eq_rf_code AS et_rf_code,
	eq_dateins AS et_dateins, --abs ti
	eq_datemes AS et_datemes, --abs ti
	NULL AS et_taille,
	NULL AS et_placemt,
	NULL AS et_localis,
	eq_comment AS et_comment,
	eq_creadat AS et_creadat,
	eq_majdate AS et_majdate,
	eq_majsrc AS et_majsrc,
	eq_abddate AS et_abddate,
	eq_abdsrc AS et_absrc
FROM t_equipement AS EQ
	LEFT JOIN t_baie AS BA ON EQ.eq_ba_code = BA.ba_code
ORDER BY ba_code ASC, et_placemt DESC
;

