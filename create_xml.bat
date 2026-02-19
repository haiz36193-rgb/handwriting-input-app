@echo off
echo ^<?xml version=\"1.0\" encoding=\"UTF-8\"?^> > C:\Users\Administrator\handwriting-input-app\backend\src\main\resources\mapper\HandwritingFeatureMapper.xml
echo ^<!DOCTYPE mapper PUBLIC \"-//mybatis.org//DTD Mapper 3.0//EN\" \"http://mybatis.org/dtd/mybatis-3-mapper.dtd\"^> >> C:\Users\Administrator\handwriting-input-app\backend\src\main\resources\mapper\HandwritingFeatureMapper.xml
echo ^<mapper namespace=\"com.handwriting.repository.HandwritingFeatureMapper\"^> >> C:\Users\Administrator\handwriting-input-app\backend\src\main\resources\mapper\HandwritingFeatureMapper.xml
echo     ^<select id=\"selectByUserId\" resultType=\"com.handwriting.model.HandwritingFeature\"^> >> C:\Users\Administrator\handwriting-input-app\backend\src\main\resources\mapper\HandwritingFeatureMapper.xml
echo         SELECT * FROM handwriting_feature WHERE user_id = #{userId} >> C:\Users\Administrator\handwriting-input-app\backend\src\main\resources\mapper\HandwritingFeatureMapper.xml
echo     ^</select^> >> C:\Users\Administrator\handwriting-input-app\backend\src\main\resources\mapper\HandwritingFeatureMapper.xml
echo ^</mapper^> >> C:\Users\Administrator\handwriting-input-app\backend\src\main\resources\mapper\HandwritingFeatureMapper.xml
