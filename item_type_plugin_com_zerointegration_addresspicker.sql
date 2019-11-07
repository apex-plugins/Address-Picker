prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_190100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2019.03.31'
,p_release=>'19.1.0.00.15'
,p_default_workspace_id=>20000002
,p_default_application_id=>105
,p_default_owner=>'ZI'
);
end;
/
prompt --application/shared_components/plugins/item_type/com_zerointegration_addresspicker
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(3571299823014728)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'COM.ZEROINTEGRATION.ADDRESSPICKER'
,p_display_name=>'0integration Address Picker'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'PROCEDURE RENDER_ADDRESSPICKER (',
'    P_ITEM IN APEX_PLUGIN.T_ITEM,',
'    P_PLUGIN IN APEX_PLUGIN.T_PLUGIN,',
'    P_PARAM IN APEX_PLUGIN.T_ITEM_RENDER_PARAM,',
'    P_RESULT IN OUT NOCOPY APEX_PLUGIN.T_ITEM_RENDER_RESULT',
'  ) AS',
'    V_HTTP_STRING VARCHAR2(32000);',
'    V_COUNTRY VARCHAR2(10);',
'    V_SHOW_GMAP VARCHAR2(10);',
'    V_MAP_WIDTH NUMBER;',
'    V_MAP_HEIGHT NUMBER;',
'    V_MAP_ZOOM NUMBER;',
'    V_POSITION VARCHAR2(10);',
'    V_C_LATITUDE NUMBER;',
'    V_C_LONGITUDE NUMBER;',
'    V_API_KEY P_ITEM.ATTRIBUTE_01%TYPE;',
'    l_name VARCHAR2(30);',
'  BEGIN',
'  ',
'    -- Debug information (if app is being run in debug mode)',
'    IF apex_application.g_debug THEN',
'      apex_plugin_util.debug_page_item ',
'        (p_plugin => p_plugin,',
'         p_page_item => p_item);',
'    END IF;',
'',
'    -- Application Plugin Attributes',
'    V_API_KEY := P_PLUGIN.ATTRIBUTE_01;',
'    ',
'    -- Component Plugin Attributes',
'    V_COUNTRY := P_ITEM.ATTRIBUTE_01;',
'    V_SHOW_GMAP := P_ITEM.ATTRIBUTE_02;',
'    V_MAP_WIDTH := P_ITEM.ATTRIBUTE_03;',
'    V_MAP_HEIGHT := P_ITEM.ATTRIBUTE_04;',
'    V_MAP_ZOOM := NVL(P_ITEM.ATTRIBUTE_05,10);',
'    V_POSITION := P_ITEM.ATTRIBUTE_06;',
'    V_C_LATITUDE := NVL(P_ITEM.ATTRIBUTE_07,0);',
'    V_C_LONGITUDE := NVL(P_ITEM.ATTRIBUTE_08,0);',
'    ',
'    APEX_JAVASCRIPT.ADD_LIBRARY(P_NAME => ''//maps.googleapis.com/maps/api/js?region=''||V_COUNTRY||''&libraries=places&key='' || V_API_KEY,',
'                                P_DIRECTORY => NULL,P_VERSION => NULL,P_SKIP_EXTENSION => TRUE);',
'',
'    APEX_JAVASCRIPT.ADD_LIBRARY(P_NAME => ''com.zerointegration.address'',P_DIRECTORY => P_PLUGIN.FILE_PREFIX,P_VERSION => NULL ,P_SKIP_EXTENSION => FALSE);',
'',
'    APEX_CSS.ADD_FILE (P_NAME => ''com.zerointegration.address'',P_DIRECTORY => P_PLUGIN.FILE_PREFIX,P_VERSION => NULL ,P_SKIP_EXTENSION => FALSE);',
'    ',
'    l_name := apex_plugin.get_input_name_for_page_item(false);',
'    ',
'    sys.htp.p(''<input type="hidden" name="'' || l_name || ''" id="'' || p_item.name || ''"/>'');',
'    ',
'    IF V_SHOW_GMAP = ''Y'' THEN',
'      ',
'      sys.htp.p(''<input id="pac-input-map" class="controls" type="text" placeholder="''||P_ITEM.PLACEHOLDER||''">'');',
'      sys.htp.p(''<div id="map-canvas" style="width:''',
'                       || V_MAP_WIDTH',
'                       || ''px; height:''',
'                       || V_MAP_HEIGHT',
'                       || ''px;"> </div>'');',
'    ',
'    ELSE',
'    ',
'      sys.htp.p(''<input id="pac-input" class="controls" type="text" placeholder="''||P_ITEM.PLACEHOLDER||''">'');',
'    ',
'    END IF;',
'        ',
'    APEX_JAVASCRIPT.ADD_ONLOAD_CODE(P_CODE => ''addressPicker("''',
'                                                || P_ITEM.NAME || ''",''''''',
'                                                || P_PARAM.VALUE || '''''',"''',
'                                                || V_COUNTRY || ''","''',
'                                                || V_SHOW_GMAP || ''",''',
'                                                || V_MAP_ZOOM || '',"''',
'                                                || V_POSITION || ''",''',
'                                                || V_C_LATITUDE || '',''',
'                                                || V_C_LONGITUDE || '')'');',
'',
'    P_RESULT.IS_NAVIGABLE := TRUE;',
'    ',
'  END RENDER_ADDRESSPICKER;'))
,p_api_version=>2
,p_render_function=>'render_addresspicker'
,p_standard_attributes=>'VISIBLE:SESSION_STATE:ESCAPE_OUTPUT:SOURCE:ELEMENT:ELEMENT_OPTION:PLACEHOLDER:ENCRYPT'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
,p_files_version=>6
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(3571891294419135)
,p_plugin_id=>wwv_flow_api.id(3571299823014728)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Google Map API Key'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_examples=>'AIzaSyCqv-cfHxu4zt88ynJQTD2a_u1nClVEpdk'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'To use the Maps JavaScript API you must have an API key. The API key is a unique identifier that is used to authenticate requests associated with your project for usage and billing purposes.',
'',
'https://developers.google.com/maps/documentation/javascript/get-api-key'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(7740584086159298)
,p_plugin_id=>wwv_flow_api.id(3571299823014728)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Restrict Country'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_examples=>'in, us, gb'
,p_help_text=>'Specify country code in lowercase.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(7741072551161806)
,p_plugin_id=>wwv_flow_api.id(3571299823014728)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Show Google Map'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_help_text=>'Display google map to select location.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(7741507487167210)
,p_plugin_id=>wwv_flow_api.id(3571299823014728)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Width'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_unit=>'px'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(7741072551161806)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'Specify Google Map width in pixel.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(7742056836170265)
,p_plugin_id=>wwv_flow_api.id(3571299823014728)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Height'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_unit=>'px'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(7741072551161806)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'Specify Google Map height in pixel.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(7742545306173300)
,p_plugin_id=>wwv_flow_api.id(3571299823014728)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Default zoom level'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'10'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(7741072551161806)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_lov_type=>'STATIC'
,p_help_text=>'Select Google map zoom level.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(7750807219343823)
,p_plugin_attribute_id=>wwv_flow_api.id(7742545306173300)
,p_display_sequence=>10
,p_display_value=>'0'
,p_return_value=>'0'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(7751222089345039)
,p_plugin_attribute_id=>wwv_flow_api.id(7742545306173300)
,p_display_sequence=>20
,p_display_value=>'1'
,p_return_value=>'1'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(7751676403345933)
,p_plugin_attribute_id=>wwv_flow_api.id(7742545306173300)
,p_display_sequence=>30
,p_display_value=>'2'
,p_return_value=>'2'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(7752029610346660)
,p_plugin_attribute_id=>wwv_flow_api.id(7742545306173300)
,p_display_sequence=>40
,p_display_value=>'3'
,p_return_value=>'3'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(7752428566347410)
,p_plugin_attribute_id=>wwv_flow_api.id(7742545306173300)
,p_display_sequence=>50
,p_display_value=>'4'
,p_return_value=>'4'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(7752820747347955)
,p_plugin_attribute_id=>wwv_flow_api.id(7742545306173300)
,p_display_sequence=>60
,p_display_value=>'5'
,p_return_value=>'5'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(7753293157349337)
,p_plugin_attribute_id=>wwv_flow_api.id(7742545306173300)
,p_display_sequence=>70
,p_display_value=>'6'
,p_return_value=>'6'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(7753671051351899)
,p_plugin_attribute_id=>wwv_flow_api.id(7742545306173300)
,p_display_sequence=>80
,p_display_value=>'7'
,p_return_value=>'7'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(7754033660352649)
,p_plugin_attribute_id=>wwv_flow_api.id(7742545306173300)
,p_display_sequence=>90
,p_display_value=>'8'
,p_return_value=>'8'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(7754458685353291)
,p_plugin_attribute_id=>wwv_flow_api.id(7742545306173300)
,p_display_sequence=>100
,p_display_value=>'9'
,p_return_value=>'9'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(7743099954174535)
,p_plugin_attribute_id=>wwv_flow_api.id(7742545306173300)
,p_display_sequence=>110
,p_display_value=>'10'
,p_return_value=>'10'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(7755975739359351)
,p_plugin_attribute_id=>wwv_flow_api.id(7742545306173300)
,p_display_sequence=>120
,p_display_value=>'11'
,p_return_value=>'11'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(7756378144360149)
,p_plugin_attribute_id=>wwv_flow_api.id(7742545306173300)
,p_display_sequence=>130
,p_display_value=>'12'
,p_return_value=>'12'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(7756719856360765)
,p_plugin_attribute_id=>wwv_flow_api.id(7742545306173300)
,p_display_sequence=>140
,p_display_value=>'13'
,p_return_value=>'13'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(7757180118361611)
,p_plugin_attribute_id=>wwv_flow_api.id(7742545306173300)
,p_display_sequence=>150
,p_display_value=>'14'
,p_return_value=>'14'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(7757586942362570)
,p_plugin_attribute_id=>wwv_flow_api.id(7742545306173300)
,p_display_sequence=>160
,p_display_value=>'15'
,p_return_value=>'15'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(7757963564363183)
,p_plugin_attribute_id=>wwv_flow_api.id(7742545306173300)
,p_display_sequence=>170
,p_display_value=>'16'
,p_return_value=>'16'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(7758340839364958)
,p_plugin_attribute_id=>wwv_flow_api.id(7742545306173300)
,p_display_sequence=>180
,p_display_value=>'17'
,p_return_value=>'17'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(7758758265365514)
,p_plugin_attribute_id=>wwv_flow_api.id(7742545306173300)
,p_display_sequence=>190
,p_display_value=>'18'
,p_return_value=>'18'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(7759149863367471)
,p_plugin_attribute_id=>wwv_flow_api.id(7742545306173300)
,p_display_sequence=>200
,p_display_value=>'19'
,p_return_value=>'19'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(7759543983369534)
,p_plugin_attribute_id=>wwv_flow_api.id(7742545306173300)
,p_display_sequence=>210
,p_display_value=>'20'
,p_return_value=>'20'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(7743519536181466)
,p_plugin_id=>wwv_flow_api.id(3571299823014728)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Device position'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(7741072551161806)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'Determine the user''s location.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(7744084545189281)
,p_plugin_id=>wwv_flow_api.id(3571299823014728)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Center latitude'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(7743519536181466)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'N'
,p_help_text=>'Latitude value for center of map.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(7744551297192250)
,p_plugin_id=>wwv_flow_api.id(3571299823014728)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Center longitude'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(7743519536181466)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'N'
,p_help_text=>'Longitude value for center of map.'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A0A202A2030696E746567726174696F6E206C6F636174696F6E205069636B657220666F7220415045580A202A20506C75672D696E20547970653A204974656D0A202A2053756D6D6172793A2053656C656374206C6F636174696F6E2066726F6D2067';
wwv_flow_api.g_varchar2_table(2) := '6F6F676C65206D617020616E642073656172636820706C616365732E0A202A0A202A205E5E5E20436F6E7461637420696E666F726D6174696F6E205E5E5E0A202A20446576656C6F7065642062792030696E746567726174696F6E0A202A20687474703A';
wwv_flow_api.g_varchar2_table(3) := '2F2F7777772E7A65726F696E746567726174696F6E2E636F6D0A202A2061706578407A65726F696E746567726174696F6E2E636F6D0A202A0A202A205E5E5E204C6963656E7365205E5E5E0A202A204C6963656E73656420556E6465723A20474E552047';
wwv_flow_api.g_varchar2_table(4) := '656E6572616C205075626C6963204C6963656E73652C2076657273696F6E2033202847504C2D332E3029202D0A687474703A2F2F7777772E6F70656E736F757263652E6F72672F6C6963656E7365732F67706C2D332E302E68746D6C0A202A0A202A2040';
wwv_flow_api.g_varchar2_table(5) := '617574686F72204B617274696B20506174656C202D207777772E7A65726F696E746567726174696F6E2E636F6D0A202A2F0A200A20237061632D696E7075742D6D6170207B0A20206261636B67726F756E642D636F6C6F723A20236666663B0A2020666F';
wwv_flow_api.g_varchar2_table(6) := '6E742D66616D696C793A20526F626F746F3B0A2020666F6E742D73697A653A20313570783B0A2020666F6E742D7765696768743A203330303B0A20206D617267696E2D6C6566743A20313270783B0A202070616464696E673A2030203131707820302031';
wwv_flow_api.g_varchar2_table(7) := '3370783B0A2020746578742D6F766572666C6F773A20656C6C69707369733B0A202077696474683A2034303070783B0A20206865696768743A20343070783B0A7D0A0A237061632D696E7075742D6D61703A666F637573207B0A2020626F726465722D63';
wwv_flow_api.g_varchar2_table(8) := '6F6C6F723A20233464393066653B0A7D0A0A696E707574237061632D696E7075742D6D61702E636F6E74726F6C73207B0A2020746F703A20313070782021696D706F7274616E743B0A20206C6566743A2031373770782021696D706F7274616E740A7D0A';
wwv_flow_api.g_varchar2_table(9) := '0A237061632D696E707574207B0A20206261636B67726F756E642D636F6C6F723A20236666663B0A2020666F6E742D66616D696C793A20526F626F746F3B0A2020666F6E742D73697A653A20313570783B0A2020666F6E742D7765696768743A20333030';
wwv_flow_api.g_varchar2_table(10) := '3B0A202070616464696E673A20302031317078203020313370783B0A2020746578742D6F766572666C6F773A20656C6C69707369733B0A202077696474683A2035303070783B0A20206865696768743A20343070783B0A7D0A0A237061632D696E707574';
wwv_flow_api.g_varchar2_table(11) := '3A666F637573207B0A2020626F726465722D636F6C6F723A20233464393066653B0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(59950017484047808)
,p_plugin_id=>wwv_flow_api.id(3571299823014728)
,p_file_name=>'com.zerointegration.address.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A2A0A202A2030696E746567726174696F6E206C6F636174696F6E205069636B657220666F7220415045580A202A20506C75672D696E20547970653A204974656D0A202A2053756D6D6172793A20476F6F676C65206D61702061646472657373207069';
wwv_flow_api.g_varchar2_table(2) := '636B657220616E64206175746F636F6D706C65746520706C7567696E2E0A202A0A202A205E5E5E20436F6E7461637420696E666F726D6174696F6E205E5E5E0A202A20446576656C6F7065642062792030696E746567726174696F6E0A202A2068747470';
wwv_flow_api.g_varchar2_table(3) := '3A2F2F7777772E7A65726F696E746567726174696F6E2E636F6D0A202A2061706578407A65726F696E746567726174696F6E2E636F6D0A202A0A202A205E5E5E204C6963656E7365205E5E5E0A202A204C6963656E73656420556E6465723A20474E5520';
wwv_flow_api.g_varchar2_table(4) := '47656E6572616C205075626C6963204C6963656E73652C2076657273696F6E2033202847504C2D332E3029202D0A687474703A2F2F7777772E6F70656E736F757263652E6F72672F6C6963656E7365732F67706C2D332E302E68746D6C0A202A0A202A20';
wwv_flow_api.g_varchar2_table(5) := '40617574686F72204B617274696B20506174656C202D207777772E7A65726F696E746567726174696F6E2E636F6D0A202A2F0A200A766172206D61703B0A766172206D61726B657273203D205B5D3B0A7661722076735F6C6F633D22222C76735F6C6174';
wwv_flow_api.g_varchar2_table(6) := '3D22222C76735F6C6E673D22222C6C6F634A736F6E446174613D22223B0A0A66756E6374696F6E20616464726573735069636B657228704974656D49442C20704974656D56616C2C2070436F756E74727952657374726963742C207053686F774D61702C';
wwv_flow_api.g_varchar2_table(7) := '20705A6F6F6D2C2070506F736974696F6E2C20704C61742C20704C6E6729200A7B0A202076617220636F756E7472795265737472696374203D207B27636F756E747279273A2070436F756E74727952657374726963747D3B0A0A2020696620287053686F';
wwv_flow_api.g_varchar2_table(8) := '774D61703D3D275927290A20207B0A202020206D6170203D206E657720676F6F676C652E6D6170732E4D617028646F63756D656E742E676574456C656D656E744279496428276D61702D63616E76617327292C200A202020207B0A2020202020207A6F6F';
wwv_flow_api.g_varchar2_table(9) := '6D3A20705A6F6F6D2C0A20202020202063656E7465723A206E657720676F6F676C652E6D6170732E4C61744C6E6728704C61742C704C6E67292C0A2020202020206D61705479706549643A20676F6F676C652E6D6170732E4D61705479706549642E524F';
wwv_flow_api.g_varchar2_table(10) := '41444D41500A202020207D293B0A2020202069662028704974656D56616C29207B0A2020202009766172206F626A203D204A534F4E2E706172736528704974656D56616C293B200A202009097365744D61726B6572286E657720676F6F676C652E6D6170';
wwv_flow_api.g_varchar2_table(11) := '732E4C61744C6E67286F626A2E414444524553535F444154412E4C415449545544452C6F626A2E414444524553535F444154412E4C4F4E474954554445292C2066616C73652C20704974656D4944293B0A097D0A09656C7365206966202870506F736974';
wwv_flow_api.g_varchar2_table(12) := '696F6E203D3D20275927290A202020207B0A2020202020202F2F205472792048544D4C352067656F6C6F636174696F6E2E0A202020202020696620286E6176696761746F722E67656F6C6F636174696F6E29207B0A20202020202020206E617669676174';
wwv_flow_api.g_varchar2_table(13) := '6F722E67656F6C6F636174696F6E2E67657443757272656E74506F736974696F6E2866756E6374696F6E28706F736974696F6E29207B0A2020202020202020202076617220706F73203D207B0A2020202020202020202020206C61743A20706F73697469';
wwv_flow_api.g_varchar2_table(14) := '6F6E2E636F6F7264732E6C617469747564652C0A2020202020202020202020206C6E673A20706F736974696F6E2E636F6F7264732E6C6F6E6769747564650A202020202020202020207D3B0A202020202020202020206D61702E73657443656E74657228';
wwv_flow_api.g_varchar2_table(15) := '706F73293B0A20202020202020207D293B0A2020202020207D20656C7365207B0A2020202020202020616C657274282242726F7773657220646F65736E277420737570706F72742047656F6C6F636174696F6E22293B0A2020202020207D0A202020207D';
wwv_flow_api.g_varchar2_table(16) := '0A2020202020200A202020202F2F20437265617465207468652073656172636820626F7820616E64206C696E6B20697420746F2074686520554920656C656D656E742E0A2020202076617220696E707574203D20646F63756D656E742E676574456C656D';
wwv_flow_api.g_varchar2_table(17) := '656E744279496428277061632D696E7075742D6D617027293B0A2020202076617220736561726368426F78203D206E657720676F6F676C652E6D6170732E706C616365732E536561726368426F7828696E707574293B0A202020206D61702E636F6E7472';
wwv_flow_api.g_varchar2_table(18) := '6F6C735B676F6F676C652E6D6170732E436F6E74726F6C506F736974696F6E2E544F505F4C4546545D2E7075736828696E707574293B0A0A202020202F2F20426961732074686520536561726368426F7820726573756C747320746F7761726473206375';
wwv_flow_api.g_varchar2_table(19) := '7272656E74206D61702076696577706F72742E0A202020206D61702E6164644C697374656E65722827626F756E64735F6368616E676564272C2066756E6374696F6E2829207B0A202020202020736561726368426F782E736574426F756E6473286D6170';
wwv_flow_api.g_varchar2_table(20) := '2E676574426F756E64732829293B0A202020207D293B0A202020200A202020202F2F204C697374656E20666F7220746865206576656E74206669726564207768656E2074686520757365722073656C6563747320612070726564696374696F6E20616E64';
wwv_flow_api.g_varchar2_table(21) := '2072657472696576650A202020202F2F206D6F72652064657461696C7320666F72207468617420706C6163652E0A20202020736561726368426F782E6164644C697374656E65722827706C616365735F6368616E676564272C2066756E6374696F6E2829';
wwv_flow_api.g_varchar2_table(22) := '207B0A20202020202076617220706C61636573203D20736561726368426F782E676574506C6163657328293B0A20202020202069662028706C616365732E6C656E677468203D3D203029207B0A202020202020202072657475726E3B0A2020202020207D';
wwv_flow_api.g_varchar2_table(23) := '0A202020202020706C616365732E666F72456163682866756E6374696F6E28706C61636529207B0A20202020202020206966202821706C6163652E67656F6D6574727929207B0A20202020202020202020636F6E736F6C652E6C6F67282252657475726E';
wwv_flow_api.g_varchar2_table(24) := '656420706C61636520636F6E7461696E73206E6F2067656F6D6574727922293B0A2020202020202020202072657475726E3B0A20202020202020207D0A2020202020207365744D61726B657228706C6163652E67656F6D657472792E6C6F636174696F6E';
wwv_flow_api.g_varchar2_table(25) := '2C20747275652C20704974656D4944293B0A2020202020207D293B0A202020207D293B0A20202020676F6F676C652E6D6170732E6576656E742E6164644C697374656E6572286D61702C2027636C69636B272C2066756E6374696F6E286576656E742920';
wwv_flow_api.g_varchar2_table(26) := '7B0A2020202020207365744D61726B6572286576656E742E6C61744C6E672C2066616C73652C20704974656D4944293B0A202020207D293B0A20207D0A2020656C73650A20207B0A2020202076617220696E707574203D2028646F63756D656E742E6765';
wwv_flow_api.g_varchar2_table(27) := '74456C656D656E744279496428277061632D696E7075742729293B0A2020200A20202020766172206175746F636F6D706C657465203D206E657720676F6F676C652E6D6170732E706C616365732E4175746F636F6D706C65746528696E7075742C0A2020';
wwv_flow_api.g_varchar2_table(28) := '202020207B0A2020202020202020636F6D706F6E656E745265737472696374696F6E733A20636F756E74727952657374726963740A2020202020207D293B0A20200A20200A2020676F6F676C652E6D6170732E6576656E742E6164644C697374656E6572';
wwv_flow_api.g_varchar2_table(29) := '286175746F636F6D706C6574652C2027706C6163655F6368616E676564272C2066756E6374696F6E2829207B0A2020202076617220706C616365203D206175746F636F6D706C6574652E676574506C61636528293B0A202020206966202821706C616365';
wwv_flow_api.g_varchar2_table(30) := '2E67656F6D6574727929207B0A20202020202072657475726E3B0A202020207D0A2020202076735F6C6F63203D20706C6163652E666F726D61747465645F616464726573733B0A0976735F6C6174203D20706C6163652E67656F6D657472792E6C6F6361';
wwv_flow_api.g_varchar2_table(31) := '74696F6E2E6C617428293B0A0976735F6C6E67203D20706C6163652E67656F6D657472792E6C6F636174696F6E2E6C6E6728293B0A096C6F634A736F6E44617461203D20277B22414444524553535F4441544122203A207B224C4154495455444522203A';
wwv_flow_api.g_varchar2_table(32) := '2022272B76735F6C61742B27222C20224C4F4E47495455444522203A2022272B76735F6C6E672B27222C20224144445245535322203A2022272B76735F6C6F632B27227D7D273B0A20202020247328704974656D49442C6C6F634A736F6E44617461293B';
wwv_flow_api.g_varchar2_table(33) := '0A2020207D20293B0A2020207D0A7D0A66756E6374696F6E207365744D61726B6572286C61746C6E672C206170706C79426F756E642C20704974656D4944290A7B0A20207661722067656F636F646572203D206E657720676F6F676C652E6D6170732E47';
wwv_flow_api.g_varchar2_table(34) := '656F636F6465723B0A202076617220696E666F77696E646F77203D206E657720676F6F676C652E6D6170732E496E666F57696E646F773B0A20200A2020666F7220287661722069203D20303B2069203C206D61726B6572732E6C656E6774683B20692B2B';
wwv_flow_api.g_varchar2_table(35) := '29200A20207B0A202020206D61726B6572735B695D2E7365744D6170286E756C6C293B0A20207D0A202067656F636F6465722E67656F636F6465287B276C6F636174696F6E273A206C61746C6E677D2C2066756E6374696F6E28726573756C74732C2073';
wwv_flow_api.g_varchar2_table(36) := '746174757329207B0A202069662028737461747573203D3D3D20274F4B2729207B0A2020202069662028726573756C74735B305D29207B0A202020202020696620286170706C79426F756E64290A2020202020207B0A20202020202020206D61702E7365';
wwv_flow_api.g_varchar2_table(37) := '745A6F6F6D283137293B0A20202020202020206D61702E73657443656E746572286C61746C6E67293B0A2020202020207D0A202020202020766172206D61726B6572203D206E657720676F6F676C652E6D6170732E4D61726B6572287B0A202020202020';
wwv_flow_api.g_varchar2_table(38) := '2020706F736974696F6E3A206C61746C6E672C0A20202020202020206D61703A206D61702C0A2020202020202020647261676761626C653A20747275650A2020202020207D293B0A202020202020696E666F77696E646F772E736574436F6E74656E7428';
wwv_flow_api.g_varchar2_table(39) := '726573756C74735B305D2E666F726D61747465645F61646472657373293B0A202020202020696E666F77696E646F772E6F70656E286D61702C206D61726B6572293B0A2020202020206D61726B6572732E70757368286D61726B6572293B0A2020202020';
wwv_flow_api.g_varchar2_table(40) := '206D61726B65722E6164644C697374656E65722827636C69636B272C2066756E6374696F6E2829207B0A2020202020202020696E666F77696E646F772E6F70656E286D61702C206D61726B6572293B0A2020202020207D293B0A20202020202076735F6C';
wwv_flow_api.g_varchar2_table(41) := '6F63203D20726573756C74735B305D2E666F726D61747465645F616464726573733B0A09202076735F6C6174203D206C61746C6E672E6C617428293B0A09202076735F6C6E67203D206C61746C6E672E6C6E6728293B0A0920206C6F634A736F6E446174';
wwv_flow_api.g_varchar2_table(42) := '61203D20277B22414444524553535F4441544122203A207B224C4154495455444522203A2022272B76735F6C61742B27222C20224C4F4E47495455444522203A2022272B76735F6C6E672B27222C20224144445245535322203A2022272B76735F6C6F63';
wwv_flow_api.g_varchar2_table(43) := '2B27227D7D273B0A0A202020202020247328704974656D49442C6C6F634A736F6E44617461293B0A202020202020202020200A202020202020676F6F676C652E6D6170732E6576656E742E6164644C697374656E6572286D61726B65722C202764726167';
wwv_flow_api.g_varchar2_table(44) := '656E64272C2066756E6374696F6E286576656E7429207B0A20202020202020207365744D61726B6572286D61726B65722E706F736974696F6E2C2066616C73652C20704974656D4944293B0A2020202020207D293B0A2020202020200A202020207D2065';
wwv_flow_api.g_varchar2_table(45) := '6C7365207B0A20202020202077696E646F772E616C65727428274E6F20726573756C747320666F756E6427293B0A202020207D0A20207D20656C7365207B0A2020202077696E646F772E616C657274282747656F636F646572206661696C656420647565';
wwv_flow_api.g_varchar2_table(46) := '20746F3A2027202B20737461747573293B0A20207D0A20207D293B0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(59950341211047810)
,p_plugin_id=>wwv_flow_api.id(3571299823014728)
,p_file_name=>'com.zerointegration.address.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
