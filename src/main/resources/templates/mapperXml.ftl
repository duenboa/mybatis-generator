<?xml version="1.0"  encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd" >
<mapper namespace="${mapperPackage}.${className}Mapper">

    <resultMap id="${modelResultMap}" type="${modelPath}">
        <#list propertyList as property>
        <#if property.isPrimaryKey == true>
        <id property="${property.propertyName}" column="${property.tablePropertyName}" />
        <#else>
        <result property="${property.propertyName}" column="${property.tablePropertyName}" />
        </#if>
        </#list>
    </resultMap>

    <sql id="selectClause">
        <#list propertyList as property>${property.tablePropertyName}<#if property_has_next>, </#if></#list>
    </sql>

    <sql id="whereClause">
        <#list propertyList as property>
        <if test="${property.propertyName} != null">
            AND ${property.tablePropertyName} = ${"#{" + property.propertyName + "}"}
        </if>
        </#list>
    </sql>

    <sql id="pageConditionWhereClause">
    <#list propertyList as property>
        <if test="query.${property.propertyName} != null">
            AND ${property.tablePropertyName} = ${"#{" + property.propertyName + "}"}
        </if>
    </#list>
    </sql>

    <sql id="updateClause">
        <#list propertyList as property>
        <if test="${property.propertyName} != null">
            ${property.tablePropertyName} = ${"#{" + property.propertyName + "}"}<#if property_has_next>,</#if>
        </if>
        </#list>
    </sql>

    <sql id="insertClause">
        <#list propertyList as property>
        <if test="${property.propertyName} != null">
            ${property.tablePropertyName},
        </if>
        </#list>
    </sql>

    <sql id="insertValues">
        <#list propertyList as property>
        <if test="${property.propertyName} != null">
            ${"#{" + property.propertyName + "}"},
        </if>
        </#list>
    </sql>

    <select id="findAll" resultMap="${modelResultMap}">
        select
            <include refid="selectClause" />
        from ${tableName}
    </select>

    <select id="findById" resultMap="${modelResultMap}">
        select
            <include refid="selectClause" />
        from ${tableName}
        where
        <#assign index=0 />
        <#list propertyList as property>
            <#if property.isPrimaryKey == true>
            <#if 0 < index>AND </#if>${property.tablePropertyName} = ${"#{" + property.propertyName + "}"}
            <#assign index=index+1 />
            </#if>
        </#list>
    </select>

    <select id="findByCondition" parameterType="${modelPath}" resultMap="${modelResultMap}">
        select
            <include refid="selectClause" />
        from ${tableName}
        <where>
            <include refid="whereClause" />
        </where>
    </select>

    <select id="findPage" resultMap="${modelResultMap}">
        select
        <include refid="selectClause" />
        from ${tableName}
    </select>

    <select id="findPageByCondition" parameterType="${modelPath}"  resultMap="${modelResultMap}">
        select
        <include refid="selectClause" />
        from ${tableName}
        <where>
            <include refid="pageConditionWhereClause" />
        </where>
    </select>

    <update id="updateById" parameterType="${modelPath}">
        update ${tableName}
        <set>
            <include refid="updateClause" />
        </set>
        where
        <#assign index=0 />
        <#list propertyList as property>
            <#if property.isPrimaryKey == true>
                <#if 0 < index>AND </#if>${property.tablePropertyName} = ${"#{" + property.propertyName + "}"}
                <#assign index=index+1 />
            </#if>
        </#list>
    </update>
    <#list propertyList as property>
        <#if property.isPrimaryKey == true>
    <insert id="save" useGeneratedKeys="true" keyProperty="${property.propertyName}" parameterType="${modelPath}">
            <#assign index=index+1 />
        </#if>
    </#list>
        insert into ${tableName}
        <trim prefix="(" suffix=")" suffixOverrides=",">
            <include refid="insertClause" />
        </trim>
        values
        <trim prefix="(" suffix=")" suffixOverrides=",">
            <include refid="insertValues" />
        </trim>
    </insert>

    <select id="count" parameterType="${modelPath}" resultType="java.lang.Long">
        select
            count(*)
        from ${tableName}
    </select>

    <select id="countByCondition" parameterType="${modelPath}" resultType="java.lang.Long">
        select
            count(*)
        from ${tableName}
        <where>
            <include refid="whereClause" />
        </where>
    </select>

    <delete id="deleteById">
        update ${tableName} set
            disabled = '1'
        where
    <#assign index=0 />
    <#list propertyList as property>
        <#if property.isPrimaryKey == true>
            <#if 0 < index>AND </#if>${property.tablePropertyName} = ${"#{" + property.propertyName + "}"}
            <#assign index=index+1 />
        </#if>
    </#list>
    </delete>

    <delete id="deleteDataById">
        delete
            from ${tableName}
        where
    <#assign index=0 />
    <#list propertyList as property>
        <#if property.isPrimaryKey == true>
            <#if 0 < index>AND </#if>${property.tablePropertyName} = ${"#{" + property.propertyName + "}"}
            <#assign index=index+1 />
        </#if>
    </#list>

    </delete>

</mapper>