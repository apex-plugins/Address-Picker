/*
 * 0integration Address Picker
 * Plug-in Type: Item
 * Summary: Google map address picker and autocomplete plugin
 *
 * ^^^ Contact information ^^^
 * Developed by 0integration
 * http://www.zerointegration.com
 * apex@zerointegration.com
 *
 * ^^^ License ^^^
 * Licensed Under: GNU General Public License, version 3 (GPL-3.0) -
http://www.opensource.org/licenses/gpl-3.0.html
 *
 * @author Kartik Patel - www.zerointegration.com
 */
 
PROCEDURE RENDER_ADDRESSPICKER (
    P_ITEM IN APEX_PLUGIN.T_ITEM,
    P_PLUGIN IN APEX_PLUGIN.T_PLUGIN,
    P_PARAM IN APEX_PLUGIN.T_ITEM_RENDER_PARAM,
    P_RESULT IN OUT NOCOPY APEX_PLUGIN.T_ITEM_RENDER_RESULT
  ) AS
    V_HTTP_STRING VARCHAR2(32000);
    V_COUNTRY VARCHAR2(10);
    V_SHOW_GMAP VARCHAR2(10);
    V_MAP_WIDTH NUMBER;
    V_MAP_HEIGHT NUMBER;
    V_MAP_ZOOM NUMBER;
    V_POSITION VARCHAR2(10);
    V_C_LATITUDE NUMBER;
    V_C_LONGITUDE NUMBER;
    V_DYNAMIC_WIDTH VARCHAR2(10);
    V_API_KEY P_ITEM.ATTRIBUTE_01%TYPE;
    l_name VARCHAR2(30);
  BEGIN
  
    -- Debug information (if app is being run in debug mode)
    IF apex_application.g_debug THEN
      apex_plugin_util.debug_page_item 
        (p_plugin => p_plugin,
         p_page_item => p_item);
    END IF;

    -- Application Plugin Attributes
    V_API_KEY := P_PLUGIN.ATTRIBUTE_01;
    
    -- Component Plugin Attributes
    V_COUNTRY := P_ITEM.ATTRIBUTE_01;
    V_SHOW_GMAP := P_ITEM.ATTRIBUTE_02;
    V_MAP_WIDTH := P_ITEM.ATTRIBUTE_03;
    V_MAP_HEIGHT := P_ITEM.ATTRIBUTE_04;
    V_MAP_ZOOM := NVL(P_ITEM.ATTRIBUTE_05,10);
    V_POSITION := P_ITEM.ATTRIBUTE_06;
    V_C_LATITUDE := NVL(P_ITEM.ATTRIBUTE_07,0);
    V_C_LONGITUDE := NVL(P_ITEM.ATTRIBUTE_08,0);
    V_DYNAMIC_WIDTH := NVL(P_ITEM.ATTRIBUTE_09,0);
    
    APEX_JAVASCRIPT.ADD_LIBRARY(P_NAME => '//maps.googleapis.com/maps/api/js?region='||V_COUNTRY||'&libraries=places&key=' || V_API_KEY,
                                P_DIRECTORY => NULL,P_VERSION => NULL,P_SKIP_EXTENSION => TRUE);

    APEX_JAVASCRIPT.ADD_LIBRARY(P_NAME => 'com.zerointegration.address',P_DIRECTORY => P_PLUGIN.FILE_PREFIX,P_VERSION => NULL ,P_SKIP_EXTENSION => FALSE);

    APEX_CSS.ADD_FILE (P_NAME => 'com.zerointegration.address',P_DIRECTORY => P_PLUGIN.FILE_PREFIX,P_VERSION => NULL ,P_SKIP_EXTENSION => FALSE);
    
    l_name := apex_plugin.get_input_name_for_page_item(false);
    
    sys.htp.p('<input type="hidden" name="' || l_name || '" id="' || p_item.name || '"/>');
    
    IF V_SHOW_GMAP = 'Y' THEN
      
      sys.htp.p('<input id="pac-input-map" class="controls" type="text" placeholder="'||P_ITEM.PLACEHOLDER||'">');
      sys.htp.p('<div id="map-canvas" style="width:'
                       || CASE WHEN V_DYNAMIC_WIDTH='Y' THEN '100%;' ELSE V_MAP_WIDTH|| 'px;' END ||' height:'
                       || V_MAP_HEIGHT
                       || 'px;"> </div>');
    
    ELSE
    
      sys.htp.p('<input id="pac-input" class="controls" type="text" placeholder="'||P_ITEM.PLACEHOLDER||'">');
    
    END IF;
        
    APEX_JAVASCRIPT.ADD_ONLOAD_CODE(P_CODE => 'addressPicker("'
                                                || P_ITEM.NAME || '",'''
                                                || P_PARAM.VALUE || ''',"'
                                                || V_COUNTRY || '","'
                                                || V_SHOW_GMAP || '",'
                                                || V_MAP_ZOOM || ',"'
                                                || V_POSITION || '",'
                                                || V_C_LATITUDE || ','
                                                || V_C_LONGITUDE || ')');

    P_RESULT.IS_NAVIGABLE := TRUE;
    
  END RENDER_ADDRESSPICKER;