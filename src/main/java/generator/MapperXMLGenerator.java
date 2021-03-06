package generator;

import freemarker.FMTemplateFactory;
import model.GenTable;
import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import util.StringUtil;
import freemarker.template.Template;
import freemarker.template.TemplateException;

import java.io.File;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.HashMap;
import java.util.Map;

/**
 * Author: liumangafei
 * Date: 2014/10/25
 * Project Name: generator
 * Description:
 */
public class MapperXMLGenerator implements Generator {

//    private static Logger logger = LoggerFactory.getLogger(MapperXMLGenerator.class);

    private GenTable genTable = null;

    public MapperXMLGenerator(GenTable genTable){
        this.genTable = genTable;
    }

    private String getModelResultMap(){
        return StringUtil.toLowerCaseFristOne(genTable.getClassName()) + "ResultMap";
    }

    private String getModelPath(){
        return genTable.getModelPackage() + "." + genTable.getClassName();
    }

    @Override
    public void generateFile(Writer out) throws IOException, TemplateException {
        Template temp = FMTemplateFactory.getTemplate("mapperXml.ftl");

        Map root = new HashMap();
        root.put("tableName", genTable.getTableName());
        root.put("propertyList", genTable.getGenPropertyList());
        root.put("mapperPackage", genTable.getMapperPackage());
        root.put("className", genTable.getClassName());
        root.put("modelResultMap", getModelResultMap());
        root.put("modelPath", getModelPath());

        temp.process(root, out);
        out.flush();
    }

    @Override
    public void generateFile(String filePath) throws IOException, TemplateException {
        Writer out = new OutputStreamWriter(FileUtils.openOutputStream(new File(filePath)));
        generateFile(out);
        out.flush();
    }

    @Override
    public void generateFile() throws IOException, TemplateException {
        generateFile(genTable.getMapperXmlPath());
    }

    public GenTable getGenTable() {
        return genTable;
    }

    public void setGenTable(GenTable genTable) {
        this.genTable = genTable;
    }
}
