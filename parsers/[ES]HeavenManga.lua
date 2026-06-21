HeavenManga=Parser:new("HeavenManga","https://heavenmanga.com","ESP","HEAVENMANGAESP",3)
HeavenManga.NSFW=true
HeavenManga.Tags={"Accion","Adulto","Artes Marciales","Acontesimientos de la Vida","Bakunyuu","Gore","Gender Bender","Humor","Harem","Hentai","Horror","Historico","Josei","Loli","Light","Lucha Libre","Manga","Mecha","Magia","Manhwa","Manhua","Mature","Misterio","Mutantes","Novela","OneShot","Psicologico","Romance","Recuentos de la vida","Smut","Shojo","Shonen","Seinen","Shoujo","Shounen","Suspenso","School Life","SuperHeroes","Supernatural","Slice of Life","Super Poderes","Torneo","Tragedia","Transexual","Vampiros","Violencia","Vida Pasadas","Vida Cotidiana","vida de escuela","Webtoon","Yaoi","Yuri","Sobrenatural","hola","Drama","ecchi","comedia","Aventura","Fantasia","Demonios","Superpoderes","Deporte","Ciencia Ficción","Supervivencia","Crimen","Reencarnación","Género Bender","Apocalíptico","Familia","Militar","Guerra","Realidad","Animación","Musica"}
HeavenManga.Keys={["Accion"]="/genero/accion.html",["Adulto"]="/genero/adulto.html",["Artes Marciales"]="/genero/artes-marciales.html",["Acontesimientos de la Vida"]="/genero/acontesimientos-de-la-vida.html",["Bakunyuu"]="/genero/bakunyuu.html",["Gore"]="/genero/gore.html",["Gender Bender"]="/genero/gender-bender.html",["Humor"]="/genero/humor.html",["Harem"]="/genero/harem.html",["Hentai"]="/genero/hentai.html",["Horror"]="/genero/horror.html",["Historico"]="/genero/historico.html",["Josei"]="/genero/josei.html",["Loli"]="/genero/loli.html",["Light"]="/genero/light.html",["Lucha Libre"]="/genero/lucha-libre.html",["Manga"]="/genero/manga.html",["Mecha"]="/genero/mecha.html",["Magia"]="/genero/magia.html",["Manhwa"]="/genero/manhwa.html",["Manhua"]="/genero/manhua.html",["Mature"]="/genero/mature.html",["Misterio"]="/genero/misterio.html",["Mutantes"]="/genero/mutantes.html",["Novela"]="/genero/novela.html",["OneShot"]="/genero/oneshot.html",["Psicologico"]="/genero/psicologico.html",["Romance"]="/genero/romance.html",["Recuentos de la vida"]="/genero/recuentos-de-la-vida.html",["Smut"]="/genero/smut.html",["Shojo"]="/genero/shojo.html",["Shonen"]="/genero/shonen.html",["Seinen"]="/genero/seinen.html",["Shoujo"]="/genero/shoujo.html",["Shounen"]="/genero/shounen.html",["Suspenso"]="/genero/suspenso.html",["School Life"]="/genero/school-life.html",["SuperHeroes"]="/genero/superheroes.html",["Supernatural"]="/genero/supernatural.html",["Slice of Life"]="/genero/slice-of-life.html",["Super Poderes"]="/genero/super-poderes.html",["Torneo"]="/genero/torneo.html",["Tragedia"]="/genero/tragedia.html",["Transexual"]="/genero/transexual.html",["Vampiros"]="/genero/vampiros.html",["Violencia"]="/genero/violencia.html",["Vida Pasadas"]="/genero/vida-pasadas.html",["Vida Cotidiana"]="/genero/vida%20-cotidiana.html",["vida de escuela"]="/genero/vida-de-escuela.html",["Webtoon"]="/genero/webtoon.html",["Yaoi"]="/genero/yaoi.html",["Yuri"]="/genero/yuri.html",["Sobrenatural"]="/genero/sobrenatural.html",["hola"]="/genero/hola.html",["Drama"]="/genero/drama.html",["ecchi"]="/genero/ecchi.html",["comedia"]="/genero/comedia.html",["Aventura"]="/genero/aventura.html",["Fantasia"]="/genero/fantasia.html",["Demonios"]="/genero/demonios.html",["Superpoderes"]="/genero/superpoderes.html",["Deporte"]="/genero/deporte.html",["Ciencia Ficción"]="/genero/ciencia-ficcion.html",["Supervivencia"]="/genero/supervivencia.html",["Crimen"]="/genero/crimen.html",["Reencarnación"]="/genero/reencarnacion.html",["Género Bender"]="/genero/genero-bender.html",["Apocalíptico"]="/genero/apocaliptico.html",["Familia"]="/genero/familia.html",["Militar"]="/genero/militar.html",["Guerra"]="/genero/guerra.html",["Realidad"]="/genero/realidad.html",["Animación"]="/genero/animacion.html",["Musica"]="/genero/musica.html"}

local function a(b)
	return b:gsub("&#([^;]-);",function(c)
		local d=tonumber("0"..c)or tonumber(c)
		return d and u8c(d)or"&#"..c..";"
	end):gsub("&(.-);",function(c)
		return HTML_entities and HTML_entities[c]and u8c(HTML_entities[c])or"&"..c..";"
	end)
end

local function e(f)
	local g={}
	Threads.insertTask(g,{Type="StringRequest",Link=f,Table=g,Index="text"})
	while Threads.check(g)do coroutine.yield(false)end
	return g.text or""
end

function HeavenManga:getManga(h,i)
	local j=e(h):gsub("\n"," "):gsub("\r"," ")
	i.NoPages=true
	for block in j:gmatch([[<div class="page%-item%-detail">(.-)<span class="book%-type"]])do
		local title=block:match([[class="manga%-name">%s*([^<]-)%s*<%/div>]])
		local link=block:match([[href="https://heavenmanga%.com(/manga/[^"]-)"]])
		local img=block:match([[src='([^']-)']])
		if title and link and img then
			i[#i+1]=CreateManga(a(title),link,img,self.ID,self.Link..link)
			i.NoPages=false
		end
	end
end

function HeavenManga:getPopularManga(n,i)
	self:getManga(self.Link.."/top?pages="..n,i)
end

function HeavenManga:getTagManga(n,i,o)
	self:getManga(self.Link..tostring(self.Keys[o]).."?pages="..n,i)
end

function HeavenManga:searchManga(p,n,i)
	local j=e(self.Link.."/buscar?query="..p):gsub("\n"," "):gsub("\r"," ")
	i.NoPages=true
	for block in j:gmatch([[<div class="page%-item%-detail">(.-)<span class="book%-type"]])do
		local title=block:match([[class="manga%-name">%s*([^<]-)%s*<%/div>]])
		local link=block:match([[href="https://heavenmanga%.com(/manga/[^"]-)"]])
		local img=block:match([[src='([^']-)']])
		if title and link and img then
			i[#i+1]=CreateManga(a(title),link,img,self.ID,self.Link..link)
		end
	end
end

function HeavenManga:getChapters(q,i)
	local api=self.Link..q.Link.."?draw=1&start=0&length=2000"
	local j=e({Link=api,Header1="X-Requested-With: XMLHttpRequest"})
	local r={}
	if j:find('"data":',1,true)then
		for id,slug in j:gmatch([["id":(%d+).-"slug":"([^"]-)"]])do
			local num=slug:match("^(%d+%.?%d*)")
			local name=num and("Capitulo "..num)or slug
			r[#r+1]={Name=name,Link="/manga/leer/"..id,Pages={},Manga=q}
		end
	end
	if#r>0 then
		table.sort(r,function(a,b)
			local ta=tonumber(a.Name:match("(%d+)"))
			local tb=tonumber(b.Name:match("(%d+)"))
			if ta and tb then return ta>tb end
			return false
		end)
	else
		local s=e(self.Link..q.Link):gsub("\n"," "):gsub("\r"," ")
		for l,cname in s:gmatch([[<a[^>]-href=".-(/manga/[^/]-/%d[^"]-)".->(.-)</a>]])do
			r[#r+1]={Name=cname,Link=l,Pages={},Manga=q}
		end
	end
	for _,c in ipairs(r)do i[#i+1]=c end
end

function HeavenManga:prepareChapter(w,i)
	local readerUrl
	if w.Link:find("^/manga/leer/",1,true)then
		readerUrl=self.Link..w.Link
	else
		readerUrl=self.Link..w.Manga.Link..w.Link
	end
	local j=e(readerUrl)
	for url in j:gmatch([["imgURL":%s*"([^"]-)"]])do
		i[#i+1]=url:gsub("\\/","/")
	end
	if#i==0 then
		j=e({Link=readerUrl,Header1="X-Requested-With: XMLHttpRequest"})
		for url in j:gmatch([["imgURL":%s*"([^"]-)"]])do
			i[#i+1]=url:gsub("\\/","/")
		end
	end
end

function HeavenManga:loadChapterPage(f,i)
	i.Link=f
end