/* gracethd_90_labo_enedis.sql */
/* Owner : GraceTHD-Community - http://gracethd-community.github.io/ */
/* Author : stephane dot byache at aleno dot eu */
/* Rev. date : 24/01/2018 */

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

/*Conception : 
https://redmine.gracethd.org/redmine/issues/429
*/

/*PostGIS*/

SET search_path TO gracethd, public;

/* ************************************ */
/* ENEDIS - Récolés appuis communs */

/*Fonctionnement : 
- Vous pouvez exécuter ce script SQL ou l'insérer dans votre fichier gracethd_90_labo.sql afin qu'il soit exécuté par GraceTHD-Check.  
- Une vue vs_wk_enedis_appui_rec sera créée. Vous pouvez l'exploiter avec vos outils SIG classiques pour exporter en shapefile comme souhaité par Enedis. 
- Le script recherche les propriétaires d'appuis correspondant aux valeurs or_nom 'ENEDIS', 'ERDF' ou 'AODE'. 
*/

/*TODO : 
# Une ligne par câble (donc doublons d'appuis) mais la géométrie est celle d'un des appuis du câble. Etrange. 
# caracteris : aïe ! C'est vraiment rejeté si on n'a pas ce "libellé" mais la capa, le modulo et le diamètre ? Il faut une correspondance entre leur liste (évolutive) p9 et les caractéristiques précises des câbles dans t_cable (cb_capafo, cb_modulo, cb_diam) pour afficher la concaténation de "Libellé, Type, Diamètre" (mais pas masse linéique ?) correspondante de cette liste. Donc sans évolution du MCD pour produire cette vilaine valeur non normalisée (au sens relationnel), il faut considérablement compliquer la requête. A voir. 
# Pour isoler ce qui doit être livré j'ai bien peur qu'il faille laisser ça à un post-traitement. Pour moi la logique serait de gérer cela avec les zones de déploiement et/ou les niveaux de référencement, et d'avoir un suivi interne interfacé avec GraceTHD. 
# Je pense qu'il est nécessaire de laisser cb_code, nd_code, pt_code dans la vue de sortes à pouvoir opérer les contrôles, le suivi et les éventuels post-traitements. 
*/


DROP VIEW IF EXISTS vs_wk_enedis_appui_rec;
CREATE VIEW vs_wk_enedis_appui_rec AS

SELECT 
	'AODE' AS Proprietai --cb_prop --ORP.or_nom AS Proprietai 
	,ORG.or_nom AS Exploitant --cb_gest
	,ST_SRID(ND.geom) AS Sys_prj --noeud.geom
	,ST_X(ND.geom) AS X --noeud.geom
	,ST_Y(ND.geom) AS Y --noeud.geom
	,LPTN.libelle AS Typ_suppo --pt_nature
	,CB.cb_capafo::TEXT || 'fo' AS Typ_cabl --cb_capafo
	,'Fibre Optique ' || CB.cb_capafo::TEXT || ' fo modulo ' || CB.cb_modulo::TEXT || ', ' || CB.cb_diam::TEXT || ' mm' AS caracteris --Manque le libellé Enedis du type de câble, le regroupement par Fo et un select pour ne pas afficher le modulo si NULL. 
	,CB.cb_dateins AS Dat_instal --cb_dateins
	--,CB.cb_lgreel AS long --En prévision	
	,PT.pt_a_haut::TEXT || 'm' AS Hauteur --pt_a_haut
	,CB.cb_comment AS Commentair --cb_comment : stocker le code affaire Enedis
	,ND.geom
	--Commenter la ligne suivante pour ne pas afficher les codes de objets concernés et être conforme au modèle. 
	,ND.nd_code,PT.pt_code,CB.cb_code AS cb_code1,CB2.cb_code AS cb_code2
FROM 
	t_ptech AS PT INNER JOIN t_noeud AS ND ON PT.pt_nd_code=ND.nd_code
	INNER JOIN t_cable AS CB ON CB.cb_nd1=ND.nd_code
	INNER JOIN t_cable AS CB2 ON CB2.cb_nd2=ND.nd_code --Commenter cette ligne pour avoir un enregistrement par appui, mais risque d'appuis manquants avec cb_nd2 non traité. 
	LEFT JOIN t_reference AS RF ON CB.cb_rf_code=RF.rf_code
	LEFT JOIN t_organisme AS ORP ON CB.cb_prop=ORP.or_code
	LEFT JOIN t_organisme AS ORG ON CB.cb_gest=ORG.or_code
	LEFT JOIN l_ptech_nature AS LPTN ON PT.pt_nature=LPTN.code
WHERE 
	PT.pt_typephy='A' --Ne traite que les points techniques de type Appui. 
	AND PT.pt_prop = (SELECT or_code FROM t_organisme WHERE or_nom='ENEDIS' OR or_nom='ERDF' OR or_nom='AODE') --dont le propriétaire est ENEDIS ou ERDF
	--AND PT.pt_prop='OR033002000000' --alternative à la ligne précédente en utilisant le or_code ENEDIS de GraceTHD-Data. 
	AND (CB.cb_statut = 'REC' OR CB.cb_statut = 'MCO') 
ORDER BY PT.pt_code
;

--ANALYZE;
